import "dart:async";

import "package:cv_app/core/assets/assets.gen.dart";
import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/data/models/location_model.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:cv_app/data/models/user_details_model.dart";
import "package:cv_app/domain/repositories/details.repository.dart";
import "package:cv_app/services/pdf_resume_service.dart";
import "package:flutter/services.dart";
import "package:mobx/mobx.dart";
import "package:navigation/structures/default/store.dart";
import "package:theme/app/app.dart";
import "package:utilities/data/sources/source.dart";
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
    final result = await _userDetailsRepository.getUserDetails();
    final details = result.second;
    if (details == null) {
      setError("Unable to load user details");
      return;
    }
    userDetails = details.copyWith(imageUrl: details.imageUrl ?? Assets.images.avatar.path);
    headerModel = HeaderModel.fromUserDetails(userDetails!);
    setLoaded();
  }

  @action
  Future<void> updateUserDetails() async {
    final current = userDetails;
    if (current == null) {
      return;
    }
    final dummy = UserDetailsModel.personal;
    userDetails = current.copyWith(
      summary: dummy.summary,
      location: dummy.location,
      experience: dummy.experience,
      education: dummy.education,
      skillGroups: dummy.skillGroups,
    );
    headerModel = HeaderModel.fromUserDetails(userDetails!);
    await _userDetailsRepository.updateUserDetailsModel(userDetails!);
    await getUserDetails();
    await refreshPdfCache();
  }

  /// Creates or replaces an experience entry and writes it to Firestore.
  @action
  Future<RequestResponse> upsertExperience(TimelineModel entry) {
    return _upsertTimeline(entry, isEducation: false);
  }

  /// Creates or replaces an education entry and writes it to Firestore.
  @action
  Future<RequestResponse> upsertEducation(TimelineModel entry) {
    return _upsertTimeline(entry, isEducation: true);
  }

  /// Removes a timeline entry and writes the document to Firestore.
  @action
  Future<RequestResponse> removeTimeline({
    required String id,
    required bool isEducation,
  }) async {
    final details = userDetails;
    if (details == null) {
      return RequestResponse.failure;
    }
    if (isEducation) {
      userDetails = details.copyWith(education: details.education.where((item) => item.id != id).toList());
    } else {
      userDetails = details.copyWith(experience: details.experience.where((item) => item.id != id).toList());
    }
    headerModel = HeaderModel.fromUserDetails(userDetails!);
    return _persistUserDetails();
  }

  Future<RequestResponse> _upsertTimeline(TimelineModel entry, {required bool isEducation}) async {
    final details = userDetails;
    if (details == null) {
      return RequestResponse.failure;
    }
    final current = isEducation ? details.education : details.experience;
    final index = current.indexWhere((item) => item.id == entry.id);
    final next = [...current];
    if (index >= 0) {
      next[index] = entry;
    } else {
      next.insert(0, entry);
    }
    userDetails = isEducation ? details.copyWith(education: next) : details.copyWith(experience: next);
    headerModel = HeaderModel.fromUserDetails(userDetails!);
    return _persistUserDetails();
  }

  /// Updates email, phone, and location, then writes the document to Firestore.
  @action
  Future<RequestResponse> updateContactDetails({
    required String? email,
    required String? phone,
    required LocationModel location,
  }) async {
    final details = userDetails;
    if (details == null) {
      return RequestResponse.failure;
    }
    userDetails = details.copyWith(
      email: email,
      phone: phone,
      location: location,
    );
    headerModel = HeaderModel.fromUserDetails(userDetails!);
    return _persistUserDetails();
  }

  Future<RequestResponse> _persistUserDetails() async {
    final details = userDetails;
    if (details == null) {
      return RequestResponse.failure;
    }
    final response = await _userDetailsRepository.updateUserDetailsModel(details);
    if (response == RequestResponse.success) {
      await refreshPdfCache();
    }
    return response;
  }

  @observable
  late HeaderModel headerModel = HeaderModel.personal;

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
      final header = HeaderModel.fromUserDetails(userDetails!);
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
