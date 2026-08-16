import "package:cv_app/domain/repositories/github/readme_document.dart";

/// A single tracked milestone from the public roadmap manifest.
class RoadmapMilestone {
  /// [RoadmapMilestone] constructor.
  const RoadmapMilestone({
    required this.title,
    this.id,
    this.category,
    this.targetDate,
    this.completedDate,
    this.status,
    this.repo,
  });

  final String title;
  final String? id;
  final String? category;
  final String? targetDate;
  final String? completedDate;
  final String? status;
  final String? repo;

  bool get isDone {
    final value = status?.toLowerCase() ?? "";
    return value.contains("done") || value.contains("complete");
  }

  bool get isInProgress => (status?.toLowerCase() ?? "").contains("progress");

  String? get displayDate => completedDate ?? targetDate;

  factory RoadmapMilestone.fromMap(Map<String, dynamic> map) {
    return RoadmapMilestone(
      id: _asString(map["id"]),
      title: _asString(map["title"] ?? map["milestone"] ?? map["name"]) ?? "",
      category: _asString(map["category"]),
      targetDate: _asString(map["targetDate"] ?? map["target_date"] ?? map["due"]),
      completedDate: _asString(map["date"] ?? map["completed"] ?? map["completed_date"]),
      status: _asString(map["status"]),
      repo: _asString(map["repo"] ?? map["repository"]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "category": category,
      "due": targetDate,
      "date": completedDate,
      "status": status,
      "repo": repo,
    };
  }
}

/// Current / next / then focus from the manifest.
class RoadmapFocus {
  /// [RoadmapFocus] constructor.
  const RoadmapFocus({
    this.current,
    this.next,
    this.then,
  });

  final String? current;
  final String? next;
  final String? then;

  String get pathSummary => [current, next, then].whereType<String>().join(" → ");

  factory RoadmapFocus.fromMap(dynamic value) {
    if (value is Map) {
      return RoadmapFocus(
        current: _asString(value["current"]),
        next: _asString(value["next"]),
        then: _asString(value["then"]),
      );
    }
    final asString = _asString(value);
    return RoadmapFocus(current: asString);
  }
}

/// A repository listed in the roadmap manifest.
class RoadmapTrackedRepo {
  /// [RoadmapTrackedRepo] constructor.
  const RoadmapTrackedRepo({
    required this.name,
    this.url,
    this.description,
    this.shortDescription,
    this.topics = const [],
    this.status,
    this.target,
    this.coverPath,
    this.thumbnailPath,
  });

  final String name;
  final String? url;
  final String? description;
  final String? shortDescription;
  final List<String> topics;
  final String? status;
  final String? target;
  final String? coverPath;
  final String? thumbnailPath;

  factory RoadmapTrackedRepo.fromMap(Map<String, dynamic> map) {
    return RoadmapTrackedRepo(
      name: _asString(map["name"]) ?? "",
      url: _asString(map["url"]),
      description: _asString(map["description"]),
      shortDescription: _asString(map["short_description"] ?? map["shortDescription"]),
      topics: _asStringList(map["topics"]),
      status: _asString(map["status"]),
      target: _asString(map["target"]),
      coverPath: _asString(map["cover_url"] ?? map["coverUrl"]),
      thumbnailPath: _asString(map["thumbnail_url"] ?? map["thumbnailUrl"]),
    );
  }
}

/// A learning category from the manifest.
class RoadmapCategory {
  /// [RoadmapCategory] constructor.
  const RoadmapCategory({
    required this.name,
    this.plannedCompletionDate,
  });

  final String name;
  final String? plannedCompletionDate;

  factory RoadmapCategory.fromMap(Map<String, dynamic> map) {
    return RoadmapCategory(
      name: _asString(map["name"]) ?? "",
      plannedCompletionDate: _asString(map["plannedCompletionDate"] ?? map["planned_completion_date"]),
    );
  }
}

/// Parsed `manifest.json` from the `ai-cyber-security-roadmap` repository.
class RoadmapSummary {
  /// [RoadmapSummary] constructor.
  const RoadmapSummary({
    this.title,
    this.status,
    this.focus = const RoadmapFocus(),
    this.lastUpdated,
    this.targetCompletion,
    this.highlights = const [],
    this.milestones = const [],
    this.progress = const {},
    this.categories = const [],
    this.repositories = const [],
    this.readme,
  });

  final String? title;
  final String? status;
  final RoadmapFocus focus;
  final String? lastUpdated;
  final String? targetCompletion;
  final List<String> highlights;
  final List<RoadmapMilestone> milestones;
  final Map<String, int> progress;
  final List<RoadmapCategory> categories;
  final List<RoadmapTrackedRepo> repositories;
  final ReadmeDocument? readme;

  String get displayTitle => title ?? "AI + Cybersecurity Roadmap";

  factory RoadmapSummary.fromMap(Map<String, dynamic> map) {
    final rawMilestones = map["milestones"] ?? map["roadmap"];
    final rawHighlights = map["highlights"];
    final rawProgress = map["progress"];
    final rawCategories = map["categories"];
    final rawRepos = map["repositories"];
    return RoadmapSummary(
      title: _asString(map["title"] ?? map["name"]),
      status: _asString(map["status"]) ?? "active",
      focus: RoadmapFocus.fromMap(map["focus"] ?? map["currentFocus"] ?? map["current_focus"] ?? map["next_milestone"]),
      lastUpdated: _formatDate(map["lastUpdated"] ?? map["last_updated"] ?? map["updated"]),
      targetCompletion: _asString(map["targetCompletion"] ?? map["target_completion"]),
      highlights: _asStringList(rawHighlights),
      milestones: rawMilestones is List
          ? rawMilestones.whereType<Map>().map((item) => RoadmapMilestone.fromMap(Map<String, dynamic>.from(item))).toList()
          : const [],
      progress: rawProgress is Map
          ? rawProgress.map((key, value) => MapEntry(key.toString(), (value is num) ? value.round() : int.tryParse("$value") ?? 0))
          : const {},
      categories: rawCategories is List
          ? rawCategories.whereType<Map>().map((item) => RoadmapCategory.fromMap(Map<String, dynamic>.from(item))).toList()
          : const [],
      repositories: rawRepos is List
          ? rawRepos.whereType<Map>().map((item) => RoadmapTrackedRepo.fromMap(Map<String, dynamic>.from(item))).toList()
          : const [],
    );
  }

  factory RoadmapSummary.fromJson(Map<String, dynamic> json) => RoadmapSummary.fromMap(json);

  RoadmapSummary copyWith({
    String? title,
    String? status,
    RoadmapFocus? focus,
    String? lastUpdated,
    String? targetCompletion,
    List<String>? highlights,
    List<RoadmapMilestone>? milestones,
    Map<String, int>? progress,
    List<RoadmapCategory>? categories,
    List<RoadmapTrackedRepo>? repositories,
    ReadmeDocument? readme,
  }) {
    return RoadmapSummary(
      title: title ?? this.title,
      status: status ?? this.status,
      focus: focus ?? this.focus,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      targetCompletion: targetCompletion ?? this.targetCompletion,
      highlights: highlights ?? this.highlights,
      milestones: milestones ?? this.milestones,
      progress: progress ?? this.progress,
      categories: categories ?? this.categories,
      repositories: repositories ?? this.repositories,
      readme: readme ?? this.readme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "status": status,
      "focus": {
        "current": focus.current,
        "next": focus.next,
        "then": focus.then,
      },
      "updated": lastUpdated,
      "targetCompletion": targetCompletion,
      "highlights": highlights,
      "milestones": milestones.map((item) => item.toMap()).toList(),
      "progress": progress,
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

String? _formatDate(dynamic value) {
  final raw = _asString(value);
  if (raw == null) {
    return null;
  }
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) {
    return raw;
  }
  final day = parsed.day.toString().padLeft(2, "0");
  final month = parsed.month.toString().padLeft(2, "0");
  return "$day/$month/${parsed.year}";
}
