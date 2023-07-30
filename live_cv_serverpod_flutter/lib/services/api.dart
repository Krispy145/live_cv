// import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
// import 'package:live_cv_serverpod_flutter/enums/types.dart';
// import 'package:live_cv_serverpod_flutter/managers/managers.dart';

// class API {
//   Future<void> insertDescription(Description description) async {
//     await Managers.flavor.client.description.insert(description);
//   }

//   Future<Description?> fetchDescriptionById(int id) async {
//     return await Managers.flavor.client.description.fetchById(id);
//   }

//   Future<List<Description>> fetchListByIds(List<int> ids) async {
//     List<Description> results = [];
//     for (int id in ids) {
//       final description = await Managers.flavor.client.description.fetchById(id);
//       if (description != null) {
//         results.add(description);
//       }
//     }
//     return results;
//   }

//   Future<List<Description>> fetchDescriptionListByType(DescriptionType type) async {
//     return await Managers.flavor.client.description.fetchListByType(type.name);
//   }

//   Future<void> insertImageDescription(ImageDescription description) async {
//     await Managers.flavor.client.imageDescription.insert(description);
//   }

//   Future<ImageDescription?> fetchImageDescriptionById(int id) async {
//     return await Managers.flavor.client.imageDescription.fetchById(id);
//   }

//   Future<List<ImageDescription>> fetchImageDescriptionListByIds(List<int> ids) async {
//     List<ImageDescription> results = [];
//     for (int id in ids) {
//       final imageDescription = await Managers.flavor.client.imageDescription.fetchById(id);
//       if (imageDescription != null) {
//         results.add(imageDescription);
//       }
//     }
//     return results;
//   }

//   Future<List<ImageDescription>> fetchImageDescriptionListByType(DescriptionType type) async {
//     return await Managers.flavor.client.imageDescription.fetchListByType(type.name);
//   }
// }
