import "package:cv_app/data/models/user_details_model.dart";
import "package:cv_app/data/sources/user_details/firestore.source.dart";
import "package:cv_app/utils/loggers.dart";
import "package:utilities/data/sources/dummy/source.dart";
import "package:utilities/data/sources/source.dart";
import "package:utilities/helpers/tuples.dart";
import "package:utilities/logger/logger.dart";

/// Dummy in-memory source for [UserDetailsModel].
class UserDetailsDummySource extends DummyDataSource<UserDetailsModel, String> {
  @override
  final List<UserDetailsModel> fakeData = [UserDetailsModel.personal];

  @override
  bool matchesID(String id, UserDetailsModel item) => item.id == id;

  @override
  bool matchesQuery(String query, UserDetailsModel item) {
    final haystack = "${item.fullName} ${item.email ?? ""}".toLowerCase();
    return haystack.contains(query.toLowerCase());
  }
}

/// Repository for personal CV details.
class UserDetailsRepository {
  /// [UserDetailsRepository] constructor.
  UserDetailsRepository({
    FirestoreUserDetailsDataSource? firestoreSource,
    UserDetailsDummySource? dummySource,
  })  : _firestore = firestoreSource ?? FirestoreUserDetailsDataSource(),
        _dummy = dummySource ?? UserDetailsDummySource();

  final FirestoreUserDetailsDataSource _firestore;
  final UserDetailsDummySource _dummy;

  /// Returns the CV user-details document, falling back to dummy data.
  Future<Pair<RequestResponse, UserDetailsModel?>> getUserDetails({
    String id = UserDetailsModel.firestoreId,
  }) async {
    try {
      final remote = await _firestore.get(id);
      final value = remote.second;
      if (remote.first == RequestResponse.success && value != null) {
        return Pair(RequestResponse.success, value.hydrateFromDummy());
      }
    } catch (error) {
      AppLogger.print("Failed to load user details from Firestore: $error", [CVAppLoggers.cvApp], type: LoggerType.error);
    }

    final fallback = await _dummy.get(id);
    return Pair(RequestResponse.success, (fallback.second ?? UserDetailsModel.personal).hydrateFromDummy());
  }

  /// Returns all stored user-detail records.
  Future<Pair<RequestResponse, List<UserDetailsModel?>>> getAllUserDetailsModels() async {
    final result = await getUserDetails();
    return Pair(result.first, [result.second]);
  }

  /// Replaces the Firestore document with mappable user details (drops `portfolio`).
  Future<RequestResponse> updateUserDetailsModel(UserDetailsModel model) async {
    final toSave = model.hydrateFromDummy().copyWith(id: UserDetailsModel.firestoreId);
    AppLogger.print(
      "Updating user details for ${toSave.fullName}",
      [CVAppLoggers.cvApp],
    );
    try {
      return await _firestore.replace(UserDetailsModel.firestoreId, toSave);
    } catch (error) {
      AppLogger.print("Failed to save user details: $error", [CVAppLoggers.cvApp], type: LoggerType.error);
      return RequestResponse.failure;
    }
  }
}
