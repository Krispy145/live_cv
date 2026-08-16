import "package:cv_app/data/models/location_model.dart";
import "package:cv_app/data/models/timeline_model.dart";

/// Personal details shown across the CV, PDF, and contact actions.
class UserDetailsModel {
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
  });

  /// Unique id.
  final String id;

  /// First name.
  final String firstName;

  /// Last name.
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

  /// Combined display name.
  String get fullName => "$firstName $lastName".trim();

  UserDetailsModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? githubUrl,
    String? linkedinUrl,
    LocationModel? location,
    String? imageUrl,
    String? summary,
    List<TimelineModel>? experience,
    List<TimelineModel>? education,
  }) {
    return UserDetailsModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      githubUrl: githubUrl ?? this.githubUrl,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      location: location ?? this.location,
      imageUrl: imageUrl ?? this.imageUrl,
      summary: summary ?? this.summary,
      experience: experience ?? this.experience,
      education: education ?? this.education,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "phone": phone,
      "githubUrl": githubUrl,
      "linkedinUrl": linkedinUrl,
      "location": location?.toMap(),
      "imageUrl": imageUrl,
      "summary": summary,
      "experience": experience.map((item) => item.toMap()).toList(),
      "education": education.map((item) => item.toMap()).toList(),
    };
  }

  factory UserDetailsModel.fromMap(Map<String, dynamic> map) {
    return UserDetailsModel(
      id: map["id"] as String? ?? "",
      firstName: map["firstName"] as String? ?? "",
      lastName: map["lastName"] as String? ?? "",
      email: map["email"] as String?,
      phone: map["phone"] as String?,
      githubUrl: map["githubUrl"] as String?,
      linkedinUrl: map["linkedinUrl"] as String?,
      location: map["location"] is Map<String, dynamic> ? LocationModel.fromMap(map["location"] as Map<String, dynamic>) : null,
      imageUrl: map["imageUrl"] as String?,
      summary: map["summary"] as String?,
      experience: (map["experience"] as List?)?.whereType<Map<String, dynamic>>().map(TimelineModel.fromMap).toList() ?? const [],
      education: (map["education"] as List?)?.whereType<Map<String, dynamic>>().map(TimelineModel.fromMap).toList() ?? const [],
    );
  }

  /// Default personal details used when no remote record exists.
  static final personal = UserDetailsModel(
    id: "personal",
    firstName: "David",
    lastName: "Kisbey-Green",
    email: "david@kisbeygreen.dev",
    githubUrl: "https://github.com/Krispy145",
    linkedinUrl: "https://www.linkedin.com/in/david-kisbey-green-24123a126",
    location: LocationModel.bishopAuckland,
    imageUrl: "assets/images/avatar.png",
    summary: "Flutter developer building cross-platform products, shared package ecosystems, and a public AI + cybersecurity learning roadmap.",
    experience: TimelineModel.experienceData,
    education: TimelineModel.educationData,
  );
}
