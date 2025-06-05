import "package:cv_app/core/assets/assets.gen.dart";
import "package:cv_package/data/models/header_model.dart";
import "package:cv_package/data/models/portfolio_model.dart";
import "package:cv_package/data/models/user_details_model.dart";
import "package:cv_package/domain/repositories/details.repository.dart";
import "package:mobx/mobx.dart";
import "package:navigation/structures/default/store.dart";
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
  }

  final UserDetailsRepository _userDetailsRepository = UserDetailsRepository();

  @observable
  UserDetailsModel? userDetails;
  Future<void> getUserDetails() async {
    setLoading();
    final userDetails = await _userDetailsRepository.getAllUserDetailsModels();
    this.userDetails = userDetails.second.first?.copyWith(imageUrl: Assets.images.avatar.path);
    setLoaded();
  }

  @action
  Future<void> addPortfolioPiece(PortfolioModel portfolio) async {
    userDetails = userDetails!.copyWith(portfolio: userDetails!.portfolio..insert(3, portfolio));
    await updateUserDetails();
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

  final DefaultShellStructureStore appWrapperStore = DefaultShellStructureStore();
}
