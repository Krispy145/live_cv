import "package:cv_app/data/models/location_model.dart";
import "package:cv_app/data/models/skill_model.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:dart_mappable/dart_mappable.dart";
import "package:utilities/helpers/tuples.dart";

part "user_details_model.mapper.dart";

/// Personal details shown across the CV, PDF, and contact actions.
@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class UserDetailsModel with UserDetailsModelMappable {
  /// Existing `user_details` document in the development Firebase project.
  static const firestoreId = "gQEeYr4Oz3412nn4Jhvt";

  /// [UserDetailsModel] constructor.
  const UserDetailsModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.githubUrl,
    this.linkedinUrl,
    this.location,
    this.imageUrl,
    this.summary,
    this.experience = const [],
    this.education = const [],
    this.skillGroups = const [],
  });

  /// Unique id.
  final String id;

  /// First name, stored in Firestore as `name`.
  @MappableField(key: "name")
  final String firstName;

  /// Last name, stored in Firestore as `surname`.
  @MappableField(key: "surname")
  final String lastName;

  /// Email address.
  final String? email;

  /// Phone number.
  final String? phone;

  /// GitHub profile URL.
  final String? githubUrl;

  /// LinkedIn profile URL.
  final String? linkedinUrl;

  /// Location.
  final LocationModel? location;

  /// Avatar path or URL.
  final String? imageUrl;

  /// Short professional summary.
  final String? summary;

  /// Professional experience.
  final List<TimelineModel> experience;

  /// Education and certifications.
  final List<TimelineModel> education;

  /// Grouped skills persisted on the user-details document.
  @MappableField(key: "skills")
  final List<SkillGroupModel> skillGroups;

  /// Combined display name.
  String get fullName => "$firstName $lastName".trim();

  /// Skills in the `(category, skills)` shape used by header and PDF.
  List<Pair<String, List<SkillModel>>> get skillsPairs =>
      skillGroups.map((group) => Pair(group.category, group.skills)).toList();

  static const fromMap = UserDetailsModelMapper.fromMap;
  static const fromJson = UserDetailsModelMapper.fromJson;

  /// Parses a Firestore document, ignoring leftover `portfolio` and string placeholders.
  factory UserDetailsModel.fromFirestore(Map<String, dynamic> map) {
    final normalized = Map<String, dynamic>.from(map);
    normalized["experience"] = _asMapList(map["experience"]);
    normalized["education"] = _asMapList(map["education"]);
    normalized["skills"] = _asMapList(map["skills"]);
    if (map["location"] is Map) {
      final location = Map<String, dynamic>.from(map["location"] as Map<dynamic, dynamic>);
      location["latitude"] = _asDouble(location["latitude"]);
      location["longitude"] = _asDouble(location["longitude"]);
      normalized["location"] = location;
    } else {
      normalized.remove("location");
    }
    normalized.remove("portfolio");
    return UserDetailsModelMapper.fromMap(normalized);
  }

  /// Fills empty structured fields from dummy data while keeping contact fields.
  UserDetailsModel hydrateFromDummy([UserDetailsModel? dummy]) {
    final fallback = dummy ?? UserDetailsModel.personal;
    return copyWith(
      location: location ?? fallback.location,
      summary: summary ?? fallback.summary,
      experience: experience.isEmpty ? fallback.experience : experience,
      education: education.isEmpty ? fallback.education : education,
      skillGroups: skillGroups.isEmpty ? fallback.skillGroups : skillGroups,
      imageUrl: imageUrl ?? fallback.imageUrl,
    );
  }

  /// Default personal details used when no remote record exists.
  static final personal = UserDetailsModel(
    id: firestoreId,
    firstName: "David",
    lastName: "Kisbey-Green",
    email: "davidkisbeygreen145@gmail.com",
    phone: "+44 7376 181 886",
    githubUrl: "https://github.com/Krispy145",
    linkedinUrl: "https://www.linkedin.com/in/david-kisbey-green-24123a126",
    location: LocationModel.bishopAuckland,
    imageUrl: "assets/images/avatar.png",
    summary: "Shipping secure, production-grade apps and APIs - with a focus on ML, auth, and DX.",
    experience: TimelineModel.experienceData,
    education: TimelineModel.educationData,
    skillGroups: SkillGroupModel.defaults,
  );

  static List<Map<String, dynamic>> _asMapList(dynamic value) {
    if (value is! List) {
      return const [];
    }
    return value.whereType<Map<dynamic, dynamic>>().map(Map<String, dynamic>.from).toList();
  }

  static double? _asDouble(dynamic value) {
    if (value is double) {
      return value;
    }
    if (value is int) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }
}
