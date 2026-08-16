/// A named skill shown as a chip on the landing page.
class SkillModel {
  /// [SkillModel] constructor.
  const SkillModel({
    required this.name,
    this.category,
  });

  /// Display name.
  final String name;

  /// Optional grouping category.
  final String? category;

  SkillModel copyWith({
    String? name,
    String? category,
  }) {
    return SkillModel(
      name: name ?? this.name,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "category": category,
    };
  }

  factory SkillModel.fromMap(Map<String, dynamic> map) {
    return SkillModel(
      name: map["name"] as String? ?? "",
      category: map["category"] as String?,
    );
  }
}
