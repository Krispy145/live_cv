/// Domain model for GitHub repository
class GitHubRepo {
  final String name;
  final String htmlUrl;
  final String description;
  final int stargazersCount;
  final int forksCount;
  final DateTime updatedAt;
  final String? language;
  final List<String> topics;
  final String visibility;
  final bool archived;
  final bool disabled;
  final String defaultBranch;
  final String? imageUrl;
  final String? thumbUrl;

  const GitHubRepo({
    required this.name,
    required this.htmlUrl,
    required this.description,
    required this.stargazersCount,
    required this.forksCount,
    required this.updatedAt,
    this.language,
    required this.topics,
    required this.visibility,
    required this.archived,
    required this.disabled,
    required this.defaultBranch,
    this.imageUrl,
    this.thumbUrl,
  });

  /// Check if repository should be displayed (public, not archived, not disabled)
  bool get isDisplayable => visibility == "public" && !archived && !disabled;

  /// Check if this is the roadmap repository
  bool get isRoadmap => name == "ai-cyber-security-roadmap";

  /// Format updated date as dd/mm/yyyy
  String get updatedAtDdMMyyyy {
    final day = updatedAt.day.toString().padLeft(2, "0");
    final month = updatedAt.month.toString().padLeft(2, "0");
    final year = updatedAt.year.toString();
    return "$day/$month/$year";
  }

  /// Get primary language or 'Other' if null
  String get displayLanguage => language ?? "Other";

  /// Get formatted star count
  String get formattedStars {
    if (stargazersCount >= 1000) {
      return "${(stargazersCount / 1000).toStringAsFixed(1)}k";
    }
    return stargazersCount.toString();
  }

  /// Get formatted fork count
  String get formattedForks {
    if (forksCount >= 1000) {
      return "${(forksCount / 1000).toStringAsFixed(1)}k";
    }
    return forksCount.toString();
  }

  /// Build cover image URL with fallback hierarchy
  String? buildCoverUrl(String username) {
    // 1. Manifest override (fastest)
    if (imageUrl != null && imageUrl!.isNotEmpty) {
      return imageUrl;
    }

    // 2. Raw URL construction (no API call)
    return "https://raw.githubusercontent.com/$username/$name/$defaultBranch/.portfolio/cover.webp";
  }

  /// Build thumbnail URL with fallback hierarchy
  String? buildThumbUrl(String username) {
    // 1. Manifest override (fastest)
    if (thumbUrl != null && thumbUrl!.isNotEmpty) {
      return thumbUrl;
    }

    // 2. Raw URL construction (no API call)
    return "https://raw.githubusercontent.com/$username/$name/$defaultBranch/.portfolio/thumbnail.webp";
  }

  /// Create a copy with updated fields
  GitHubRepo copyWith({
    String? name,
    String? htmlUrl,
    String? description,
    int? stargazersCount,
    int? forksCount,
    DateTime? updatedAt,
    String? language,
    List<String>? topics,
    String? visibility,
    bool? archived,
    bool? disabled,
    String? defaultBranch,
    String? imageUrl,
    String? thumbUrl,
  }) {
    return GitHubRepo(
      name: name ?? this.name,
      htmlUrl: htmlUrl ?? this.htmlUrl,
      description: description ?? this.description,
      stargazersCount: stargazersCount ?? this.stargazersCount,
      forksCount: forksCount ?? this.forksCount,
      updatedAt: updatedAt ?? this.updatedAt,
      language: language ?? this.language,
      topics: topics ?? this.topics,
      visibility: visibility ?? this.visibility,
      archived: archived ?? this.archived,
      disabled: disabled ?? this.disabled,
      defaultBranch: defaultBranch ?? this.defaultBranch,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbUrl: thumbUrl ?? this.thumbUrl,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GitHubRepo && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => "GitHubRepo(name: $name, language: $language)";
}
