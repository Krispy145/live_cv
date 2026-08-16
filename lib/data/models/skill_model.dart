/// Proficiency shown next to a skill chip.
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
class SkillModel {
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

  SkillModel copyWith({
    String? name,
    String? category,
    SkillProficiency? proficiency,
  }) {
    return SkillModel(
      name: name ?? this.name,
      category: category ?? this.category,
      proficiency: proficiency ?? this.proficiency,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "category": category,
      "proficiency": proficiency.name,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      name: map["name"] as String? ?? "",
      category: map["category"] as String?,
      proficiency: SkillProficiency.values.firstWhere(
        (value) => value.name == map["proficiency"],
        orElse: () => SkillProficiency.developing,
      ),
    );
  }
}
