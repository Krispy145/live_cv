import "package:dart_mappable/dart_mappable.dart";

part "skill_model.mapper.dart";

/// Proficiency shown next to a skill chip.
@MappableEnum()
enum SkillProficiency {
  exploring,
  developing,
  proficient,
  specialized;

  /// Emoji used in the skills legend and chips.
  String get emoji => switch (this) {
        SkillProficiency.exploring => "🌱",
        SkillProficiency.developing => "⚡",
        SkillProficiency.proficient => "🚀",
        SkillProficiency.specialized => "🧬",
      };

  /// Human-readable label.
  String get label => switch (this) {
        SkillProficiency.exploring => "Exploring",
        SkillProficiency.developing => "Developing",
        SkillProficiency.proficient => "Proficient",
        SkillProficiency.specialized => "Specialized",
      };
}

/// A named skill shown as a chip on the landing page.
@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class SkillModel with SkillModelMappable {
  /// [SkillModel] constructor.
  const SkillModel({
    required this.name,
    this.category,
    this.proficiency = SkillProficiency.developing,
  });

  /// Display name.
  final String name;

  /// Optional grouping category.
  final String? category;

  /// How comfortable the skill is.
  final SkillProficiency proficiency;

  static const fromMap = SkillModelMapper.fromMap;
  static const fromJson = SkillModelMapper.fromJson;
}

/// Skills grouped under a category for Firestore and the landing page.
@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class SkillGroupModel with SkillGroupModelMappable {
  /// [SkillGroupModel] constructor.
  const SkillGroupModel({
    required this.category,
    this.skills = const [],
  });

  /// Group label, e.g. `Flutter`.
  final String category;

  /// Skills in this group.
  final List<SkillModel> skills;

  static const fromMap = SkillGroupModelMapper.fromMap;
  static const fromJson = SkillGroupModelMapper.fromJson;

  static List<SkillModel> _skills(String category, SkillProficiency proficiency, List<String> names) {
    return names.map((name) => SkillModel(name: name, category: category, proficiency: proficiency)).toList();
  }

  /// Default grouped skills used by dummy data and first Firestore seed.
  static final List<SkillGroupModel> defaults = [
    SkillGroupModel(
      category: "Flutter",
      skills: _skills("Flutter", SkillProficiency.specialized, [
        "Dart",
        "Dio",
        "Firebase",
        "Firebase Hosting",
        "Firestore",
      ]),
    ),
    SkillGroupModel(
      category: "React",
      skills: [
        ..._skills("React", SkillProficiency.proficient, ["JavaScript", "TypeScript"]),
        ..._skills("React", SkillProficiency.developing, ["React"]),
        ..._skills("React", SkillProficiency.exploring, ["Axios", "Vite"]),
      ],
    ),
    SkillGroupModel(
      category: "React Native",
      skills: [
        ..._skills("React Native", SkillProficiency.developing, ["React Native"]),
        ..._skills("React Native", SkillProficiency.exploring, [
          "Expo",
          "Expo Secure Store",
          "React Navigation",
          "Zustand",
        ]),
      ],
    ),
    SkillGroupModel(
      category: "Backend & APIs",
      skills: [
        ..._skills("Backend & APIs", SkillProficiency.specialized, ["GitHub Actions"]),
        ..._skills("Backend & APIs", SkillProficiency.developing, ["Python", "REST APIs"]),
        ..._skills("Backend & APIs", SkillProficiency.exploring, ["Docker", "Docker Compose"]),
      ],
    ),
    SkillGroupModel(
      category: "AI & Data",
      skills: _skills("AI & Data", SkillProficiency.developing, [
        "Jupyter",
        "LangChain",
        "OpenAI API",
        "Pandas/NumPy (ML)",
        "scikit-learn",
      ]),
    ),
    SkillGroupModel(
      category: "Security & DevOps",
      skills: [
        ..._skills("Security & DevOps", SkillProficiency.proficient, ["CI/CD"]),
        ..._skills("Security & DevOps", SkillProficiency.exploring, [
          "CompTIA Security+ (Prep)",
          "JWT",
          "Linux",
          "OAuth2 / OIDC",
        ]),
      ],
    ),
    SkillGroupModel(
      category: "General Tools",
      skills: [
        ..._skills("General Tools", SkillProficiency.specialized, ["Git"]),
        ..._skills("General Tools", SkillProficiency.proficient, ["CI/CD"]),
        ..._skills("General Tools", SkillProficiency.developing, ["Figma", "Google Cloud Platform (GCP)"]),
      ],
    ),
  ];
}
