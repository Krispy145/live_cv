/// A single tracked milestone from the public roadmap manifest.
class RoadmapMilestone {
  /// [RoadmapMilestone] constructor.
  const RoadmapMilestone({
    required this.title,
    this.category,
    this.targetDate,
    this.status,
  });

  final String title;
  final String? category;
  final String? targetDate;
  final String? status;

  factory RoadmapMilestone.fromMap(Map<String, dynamic> map) {
    return RoadmapMilestone(
      title: _asString(map["title"] ?? map["milestone"] ?? map["name"]) ?? "",
      category: _asString(map["category"]),
      targetDate: _asString(map["targetDate"] ?? map["target_date"] ?? map["due"] ?? map["date"]),
      status: _asString(map["status"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "category": category,
      "targetDate": targetDate,
      "status": status,
    };
  }
}

/// Parsed `manifest.json` from the `ai-cyber-security-roadmap` repository.
class RoadmapSummary {
  /// [RoadmapSummary] constructor.
  const RoadmapSummary({
    this.title,
    this.status,
    this.focus,
    this.lastUpdated,
    this.targetCompletion,
    this.highlights = const [],
    this.milestones = const [],
  });

  final String? title;
  final String? status;
  final String? focus;
  final String? lastUpdated;
  final String? targetCompletion;
  final List<String> highlights;
  final List<RoadmapMilestone> milestones;

  factory RoadmapSummary.fromMap(Map<String, dynamic> map) {
    final rawMilestones = map["milestones"] ?? map["roadmap"];
    final rawHighlights = map["highlights"];
    final nextMilestone = map["next_milestone"] ?? map["nextMilestone"];
    return RoadmapSummary(
      title: _asString(map["title"] ?? map["name"]),
      status: _asString(map["status"]),
      focus: _asString(map["focus"] ?? map["currentFocus"] ?? map["current_focus"] ?? nextMilestone),
      lastUpdated: _asString(map["lastUpdated"] ?? map["last_updated"] ?? map["updated"]),
      targetCompletion: _asString(map["targetCompletion"] ?? map["target_completion"]),
      highlights: _asStringList(rawHighlights),
      milestones: rawMilestones is List
          ? rawMilestones.whereType<Map>().map((item) => RoadmapMilestone.fromMap(Map<String, dynamic>.from(item))).toList()
          : const [],
    );
  }

  factory RoadmapSummary.fromJson(Map<String, dynamic> json) => RoadmapSummary.fromMap(json);

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "status": status,
      "focus": focus,
      "lastUpdated": lastUpdated,
      "targetCompletion": targetCompletion,
      "highlights": highlights,
      "milestones": milestones.map((item) => item.toMap()).toList(),
    };
  }
}

/// Mapper hook retained from the original dart_mappable setup.
class RoadmapSummaryMapper {
  /// No-op initializer kept so existing `main()` calls continue to compile.
  static void ensureInitialized() {}
}

String? _asString(dynamic value) {
  if (value == null) {
    return null;
  }
  if (value is String) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
  if (value is num || value is bool) {
    return value.toString();
  }
  if (value is Map) {
    for (final key in ["current", "title", "name", "text", "value", "status", "state", "label"]) {
      final nested = _asString(value[key]);
      if (nested != null) {
        return nested;
      }
    }
  }
  return null;
}

List<String> _asStringList(dynamic value) {
  if (value is! List) {
    return const [];
  }
  return value.map(_asString).whereType<String>().toList();
}
