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

  static List<SkillModel> _skills(String category, SkillProficiency proficiency, List<String> names) {
    return names.map((name) => SkillModel(name: name, category: category, proficiency: proficiency)).toList();
  }

  /// Default personal header.
  static final personal = HeaderModel(
    title: "David Kisbey-Green",
    subtitle: "Flutter Developer  ·  AI + Cybersecurity",
    userDetails: UserDetailsModel.personal,
    skillsPairs: [
      Pair("Flutter", [
        ..._skills("Flutter", SkillProficiency.specialized, [
          "Dart",
          "Dio",
          "Firebase",
          "Firebase Hosting",
          "Firestore",
          "Flutter",
          "GetIt",
          "MobX",
        ]),
        ..._skills("Flutter", SkillProficiency.proficient, ["AutoRoute", "Hive"]),
        ..._skills("Flutter", SkillProficiency.developing, ["BLoC", "Riverpod"]),
      ]),
      Pair("React", [
        ..._skills("React", SkillProficiency.proficient, ["JavaScript", "TypeScript"]),
        ..._skills("React", SkillProficiency.developing, ["React"]),
        ..._skills("React", SkillProficiency.exploring, ["Axios", "Vite"]),
      ]),
      Pair("React Native", [
        ..._skills("React Native", SkillProficiency.developing, ["React Native"]),
        ..._skills("React Native", SkillProficiency.exploring, [
          "Expo",
          "Expo Secure Store",
          "React Navigation",
          "Zustand",
        ]),
      ]),
      Pair("Backend & APIs", [
        ..._skills("Backend & APIs", SkillProficiency.specialized, ["GitHub Actions"]),
        ..._skills("Backend & APIs", SkillProficiency.developing, ["Python", "REST APIs"]),
        ..._skills("Backend & APIs", SkillProficiency.exploring, [
          "Docker",
          "Docker Compose",
          "FastAPI",
          "WebSockets",
        ]),
      ]),
      Pair("AI & Data", [
        ..._skills("AI & Data", SkillProficiency.developing, [
          "Jupyter",
          "LangChain",
          "OpenAI API",
          "Pandas/NumPy (ML)",
          "scikit-learn",
        ]),
        ..._skills("AI & Data", SkillProficiency.exploring, ["Vector DB (Weaviate/Pinecone)"]),
      ]),
      Pair("Security & DevOps", [
        ..._skills("Security & DevOps", SkillProficiency.proficient, ["CI/CD"]),
        ..._skills("Security & DevOps", SkillProficiency.exploring, [
          "CompTIA Security+ (Prep)",
          "JWT",
          "Linux",
          "OAuth2 / OIDC",
          "OWASP Top 10",
          "Threat Modeling (STRIDE)",
        ]),
      ]),
    ],
  );
}
