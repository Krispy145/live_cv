import "package:cv_app/data/models/skill_model.dart";
import "package:cv_app/data/models/user_details_model.dart";
import "package:utilities/helpers/tuples.dart";

/// Header content for the landing hero and generated resume.
class HeaderModel {
  /// [HeaderModel] constructor.
  const HeaderModel({
    required this.title,
    required this.userDetails,
    this.subtitle,
    this.skillsPairs = const [],
  });

  /// Primary headline.
  final String title;

  /// Optional supporting subtitle.
  final String? subtitle;

  /// Personal details attached to this header.
  final UserDetailsModel userDetails;

  /// Skills grouped as `(category, skills)`.
  final List<Pair<String, List<SkillModel>>> skillsPairs;

  /// Flat skill list used by the header chips.
  List<SkillModel> get skills => skillsPairs.expand((pair) => pair.second).toList();

  HeaderModel copyWith({
    String? title,
    String? subtitle,
    UserDetailsModel? userDetails,
    List<Pair<String, List<SkillModel>>>? skillsPairs,
  }) {
    return HeaderModel(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      userDetails: userDetails ?? this.userDetails,
      skillsPairs: skillsPairs ?? this.skillsPairs,
    );
  }

  /// Default personal header.
  static final personal = HeaderModel(
    title: "David Kisbey-Green",
    subtitle: "Software Engineer — Flutter / TypeScript / AWS / PostgreSQL",
    userDetails: UserDetailsModel.personal,
    skillsPairs: UserDetailsModel.personal.skillsPairs,
  );

  /// Header built from a Firestore (or dummy) [UserDetailsModel].
  factory HeaderModel.fromUserDetails(UserDetailsModel details) {
    return personal.copyWith(
      title: details.fullName,
      userDetails: details,
      skillsPairs: details.skillsPairs,
    );
  }
}
