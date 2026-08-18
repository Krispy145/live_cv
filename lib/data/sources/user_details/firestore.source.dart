import "package:cloud_firestore/cloud_firestore.dart";
import "package:cv_app/data/models/user_details_model.dart";
import "package:utilities/data/models/basic_search_query_model.dart";
import "package:utilities/data/sources/firestore/source.dart";
import "package:utilities/data/sources/source.dart";
import "package:utilities/helpers/tuples.dart";

/// Firestore source for the `user_details` collection.
class FirestoreUserDetailsDataSource extends FirestoreDataSource<UserDetailsModel, BasicSearchQueryModel> {
  /// [FirestoreUserDetailsDataSource] constructor.
  FirestoreUserDetailsDataSource({
    String collectionName = "user_details",
  }) : super(
          collectionName,
          convertDataTypeFromMap: UserDetailsModel.fromFirestore,
          convertDataTypeToMap: (model) => model.toMap(),
          titleFromType: (model) => model.fullName,
        );

  @override
  Query<Map<String, dynamic>> buildQuery(
    BasicSearchQueryModel query,
    Query<Map<String, dynamic>> collectionReference,
  ) {
    return collectionReference.where("name", isGreaterThanOrEqualTo: query.searchTerm);
  }

  @override
  UserDetailsModel convertFromMap(Map<String, dynamic> data) {
    return convertDataTypeFromMap(_decodeTimestamps(data) as Map<String, dynamic>);
  }

  /// Replaces the document entirely so leftover fields such as `portfolio` are removed.
  Future<RequestResponse> replace(String id, UserDetailsModel model) async {
    try {
      await collectionReference.doc(id).set(convertToMap(model.copyWith(id: id)));
      return RequestResponse.success;
    } catch (_) {
      return RequestResponse.failure;
    }
  }

  /// Loads a single document, typically [UserDetailsModel.firestoreId].
  Future<Pair<RequestResponse, UserDetailsModel?>> getById(String id) async {
    return get(id);
  }

  dynamic _decodeTimestamps(dynamic value) {
    if (value is Timestamp) {
      return value.toDate().toIso8601String();
    }
    if (value is Map) {
      return value.map((key, nested) => MapEntry(key.toString(), _decodeTimestamps(nested)));
    }
    if (value is List) {
      return value.map(_decodeTimestamps).toList();
    }
    return value;
  }
}
