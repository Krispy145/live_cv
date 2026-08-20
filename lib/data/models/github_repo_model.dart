import "package:flutter/material.dart";

/// A GitHub repository card model, optionally enriched from the roadmap manifest.
class GitHubRepoModel {
  /// [GitHubRepoModel] constructor.
  const GitHubRepoModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.htmlUrl,
    this.description,
    this.shortDescription,
    this.language,
    this.stargazersCount = 0,
    this.forksCount = 0,
    this.topics = const [],
    this.updatedAt,
    this.pushedAt,
    this.defaultBranch,
    this.homepage,
    this.fork = false,
    this.archived = false,
    this.private = false,
    this.status,
    this.coverUrl,
    this.thumbnailUrl,
    this.displayTitle,
    this.targetDate,
  });

  final int id;
  final String name;
  final String fullName;
  final String htmlUrl;
  final String? description;
  final String? shortDescription;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final List<String> topics;
  final DateTime? updatedAt;
  final DateTime? pushedAt;
  final String? defaultBranch;
  final String? homepage;
  final bool fork;
  final bool archived;
  final bool private;
  final String? status;
  final String? coverUrl;
  final String? thumbnailUrl;
  final String? displayTitle;
  final String? targetDate;

  /// GitHub topic used to keep a public repo off the CV portfolio.
  static const hiddenFromCvTopic = "not-for-cv";

  bool get isRoadmap => name == "ai-cyber-security-roadmap";

  bool get isHiddenFromCv => topics.any((topic) => topic.toLowerCase() == hiddenFromCvTopic);

  bool get isPortfolioRepo => !private && !isHiddenFromCv;

  bool get isActive => (status ?? "").toLowerCase() == "active";

  DateTime? get lastActivity => pushedAt ?? updatedAt;

  String get title => displayTitle ?? _titleFromSlug(name);

  String get cardDescription => shortDescription ?? description ?? "";

  String get statusLabel {
    final value = status ?? "";
    if (value.isEmpty) {
      return "Active";
    }
    return value.split("_").map((part) => part.isEmpty ? part : "${part[0].toUpperCase()}${part.substring(1)}").join(" ");
  }

  factory GitHubRepoModel.fromMap(Map<String, dynamic> map) {
    return GitHubRepoModel(
      id: map["id"] as int? ?? 0,
      name: map["name"] as String? ?? "",
      fullName: map["full_name"] as String? ?? "",
      htmlUrl: map["html_url"] as String? ?? "",
      description: map["description"] as String?,
      shortDescription: map["short_description"] as String?,
      language: map["language"] as String?,
      stargazersCount: map["stargazers_count"] as int? ?? 0,
      forksCount: map["forks_count"] as int? ?? 0,
      topics: (map["topics"] as List?)?.cast<String>() ?? const [],
      updatedAt: DateTime.tryParse(map["updated_at"] as String? ?? ""),
      pushedAt: DateTime.tryParse(map["pushed_at"] as String? ?? ""),
      defaultBranch: map["default_branch"] as String?,
      homepage: map["homepage"] as String?,
      fork: map["fork"] as bool? ?? false,
      archived: map["archived"] as bool? ?? false,
      private: map["private"] as bool? ?? false,
      status: map["status"] as String?,
      coverUrl: map["cover_url"] as String?,
      thumbnailUrl: map["thumbnail_url"] as String?,
      displayTitle: map["display_title"] as String?,
      targetDate: map["target"] as String?,
    );
  }

  GitHubRepoModel copyWith({
    int? id,
    String? name,
    String? fullName,
    String? htmlUrl,
    String? description,
    String? shortDescription,
    String? language,
    int? stargazersCount,
    int? forksCount,
    List<String>? topics,
    DateTime? updatedAt,
    DateTime? pushedAt,
    String? defaultBranch,
    String? homepage,
    bool? fork,
    bool? archived,
    bool? private,
    String? status,
    String? coverUrl,
    String? thumbnailUrl,
    String? displayTitle,
    String? targetDate,
  }) {
    return GitHubRepoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      description: description ?? this.description,
      shortDescription: shortDescription ?? this.shortDescription,
      language: language ?? this.language,
      stargazersCount: stargazersCount ?? this.stargazersCount,
      forksCount: forksCount ?? this.forksCount,
      topics: topics ?? this.topics,
      updatedAt: updatedAt ?? this.updatedAt,
      pushedAt: pushedAt ?? this.pushedAt,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      homepage: homepage ?? this.homepage,
      fork: fork ?? this.fork,
      archived: archived ?? this.archived,
      private: private ?? this.private,
      status: status ?? this.status,
      coverUrl: coverUrl ?? this.coverUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      displayTitle: displayTitle ?? this.displayTitle,
      targetDate: targetDate ?? this.targetDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "full_name": fullName,
      "html_url": htmlUrl,
      "description": description,
      "short_description": shortDescription,
      "language": language,
      "stargazers_count": stargazersCount,
      "forks_count": forksCount,
      "topics": topics,
      "updated_at": updatedAt?.toIso8601String(),
      "pushed_at": pushedAt?.toIso8601String(),
      "default_branch": defaultBranch,
      "homepage": homepage,
      "fork": fork,
      "archived": archived,
      "private": private,
      "status": status,
      "cover_url": coverUrl,
      "thumbnail_url": thumbnailUrl,
      "display_title": displayTitle,
      "target": targetDate,
    };
  }
}

String _titleFromSlug(String slug) {
  return slug.split(RegExp("[-_]")).where((part) => part.isNotEmpty).map((part) => "${part[0].toUpperCase()}${part.substring(1)}").join(" ");
}

/// GitHub-style language colors used on project cards.
Color languageColor(String? language) {
  switch (language) {
    case "Python":
      return const Color(0xFF3572A5);
    case "TypeScript":
      return const Color(0xFF3178C6);
    case "JavaScript":
      return const Color(0xFFF1E05A);
    case "Dart":
      return const Color(0xFF00B4AB);
    case "Jupyter Notebook":
      return const Color(0xFFDA5B0B);
    default:
      return const Color(0xFF8B949E);
  }
}

/// Title-cases a GitHub topic slug.
String titleCaseTopic(String topic) {
  return topic.split(RegExp("[-_]")).where((part) => part.isNotEmpty).map((part) => "${part[0].toUpperCase()}${part.substring(1)}").join(" ");
}
