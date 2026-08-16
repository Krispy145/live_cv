import "package:cv_app/data/models/user_details_model.dart";
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
  UserDetailsRepository({DummyDataSource<UserDetailsModel, String>? source}) : _source = source ?? UserDetailsDummySource();

  final DummyDataSource<UserDetailsModel, String> _source;

  /// Returns all stored user-detail records.
  Future<Pair<RequestResponse, List<UserDetailsModel?>>> getAllUserDetailsModels() {
    return _source.getAll();
  }

  /// Persists an updated [UserDetailsModel].
  Future<RequestResponse> updateUserDetailsModel(UserDetailsModel model) async {
    AppLogger.print(
      "Updating user details for ${model.fullName}",
      [CVAppLoggers.cvApp],
    );
    return _source.update(model.id, model);
  }
}
