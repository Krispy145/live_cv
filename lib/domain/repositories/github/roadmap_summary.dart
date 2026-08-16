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
      title: (map["title"] ?? map["milestone"] ?? map["name"] ?? "") as String,
      category: map["category"] as String?,
      targetDate: (map["targetDate"] ?? map["target_date"] ?? map["due"]) as String?,
      status: map["status"] as String?,
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
    return RoadmapSummary(
      title: (map["title"] ?? map["name"]) as String?,
      status: map["status"] as String?,
      focus: (map["focus"] ?? map["currentFocus"] ?? map["current_focus"]) as String?,
      lastUpdated: (map["lastUpdated"] ?? map["last_updated"] ?? map["updated"]) as String?,
      targetCompletion: (map["targetCompletion"] ?? map["target_completion"]) as String?,
      highlights: rawHighlights is List ? rawHighlights.map((item) => item.toString()).toList() : const [],
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
