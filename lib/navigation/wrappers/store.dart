import "dart:async";

import "package:cv_app/core/assets/assets.gen.dart";
import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:cv_app/data/models/user_details_model.dart";
import "package:cv_app/domain/repositories/details.repository.dart";
import "package:cv_app/services/pdf_resume_service.dart";
import "package:flutter/services.dart";
import "package:mobx/mobx.dart";
import "package:navigation/structures/default/store.dart";
import "package:theme/app/app.dart";
import "package:utilities/widgets/load_state/store.dart";

part "store.g.dart";

/// [AppStore] is a class that uses [_AppStore] to manage the state of the App feature.
class AppStore = _AppStore with _$AppStore;

/// [_AppStore] is a class that manages the state of the App feature.
abstract class _AppStore with LoadStateStore, Store {
  /// [AppStore] constructor.
  _AppStore();

  /// [initialize] is a method that initializes the store.
  Future<void> initialize() async {
    await getUserDetails();
    // Generate PDF in background for faster access
    await _generatePdfInBackground();
  }

  final UserDetailsRepository _userDetailsRepository = UserDetailsRepository();

  @observable
  UserDetailsModel? userDetails;
  Future<void> getUserDetails() async {
    setLoading();
    final userDetails = await _userDetailsRepository.getAllUserDetailsModels();
    this.userDetails = userDetails.second.first?.copyWith(
      imageUrl: Assets.images.avatar.path,
      // Add experience and education data from the static data
      experience: TimelineModel.experienceData,
      education: TimelineModel.educationData,
    );
    setLoaded();
  }

  @action
  Future<void> updateUserDetails() async {
    if (userDetails != null) {
      await _userDetailsRepository.updateUserDetailsModel(userDetails!);
      await getUserDetails();
    }
  }

  @observable
  late HeaderModel headerModel = HeaderModel.personal.copyWith(userDetails: userDetails);

  @observable
  Uint8List? cachedPdfBytes;

  @observable
  bool isPdfGenerating = false;

  @observable
  String? pdfError;

  final DefaultShellStructureStore appWrapperStore = DefaultShellStructureStore();

  /// Generate PDF in background for caching
  Future<void> _generatePdfInBackground() async {
    if (userDetails == null) return;

    isPdfGenerating = true;
    pdfError = null;

    try {
      final header = HeaderModel.personal.copyWith(userDetails: userDetails);
      final imageBytes = await _loadImageBytes();
      final colorModel = AppTheme.baseThemeModel!.colors["primary"]!.light;
      cachedPdfBytes = await PdfResumeService.generateResume(
        header,
        colorModel: colorModel,
        imageBytes: imageBytes,
      );
    } catch (e) {
      pdfError = e.toString();
      print("Error generating PDF in background: $e");
    } finally {
      isPdfGenerating = false;
    }
  }

  /// Load image bytes for PDF generation
  Future<Uint8List?> _loadImageBytes() async {
    final imageUrl = userDetails?.imageUrl;
    if (imageUrl == null || imageUrl.isEmpty) {
      return null;
    }

    // Use microtask to avoid blocking the main UI thread
    return Future.microtask(() async {
      try {
        // For asset images, load from rootBundle
        if (imageUrl.startsWith("assets/")) {
          final data = await rootBundle.load(imageUrl);
          return data.buffer.asUint8List();
        }

        // For network images, you would need to implement HTTP loading
        // For now, return null to use placeholder
        return null;
      } catch (e) {
        print("Error loading image: $e");
        return null;
      }
    });
  }

  /// Get cached PDF or generate if not available
  Future<Uint8List?> getCachedPdf() async {
    if (cachedPdfBytes != null) {
      return cachedPdfBytes;
    }

    // If not cached, generate it
    await _generatePdfInBackground();
    return cachedPdfBytes;
  }

  /// Refresh PDF cache
  @action
  Future<void> refreshPdfCache() async {
    cachedPdfBytes = null;
    await _generatePdfInBackground();
  }
}
