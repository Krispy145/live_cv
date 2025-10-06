import "package:cv_app/features/github/domain/github_repo.dart";

/// Data Transfer Object for GitHub repository data
class GitHubRepoDto {
  final String name;
  final String htmlUrl;
  final String? description;
  final int stargazersCount;
  final int forksCount;
  final String updatedAt;
  final String? language;
  final List<String> topics;
  final String visibility;
  final bool archived;
  final bool disabled;
  final String defaultBranch;

  const GitHubRepoDto({
    required this.name,
    required this.htmlUrl,
    this.description,
    required this.stargazersCount,
    required this.forksCount,
    required this.updatedAt,
    this.language,
    required this.topics,
    required this.visibility,
    required this.archived,
    required this.disabled,
    required this.defaultBranch,
  });

  /// Create DTO from GitHub API response
  factory GitHubRepoDto.fromJson(Map<String, dynamic> json) {
    return GitHubRepoDto(
      name: json["name"] as String? ?? "",
      htmlUrl: json["html_url"] as String? ?? "",
      description: json["description"] as String?,
      stargazersCount: json["stargazers_count"] as int? ?? 0,
      forksCount: json["forks_count"] as int? ?? 0,
      updatedAt: json["updated_at"] as String? ?? "",
      language: json["language"] as String?,
      topics: List<String>.from((json["topics"] as List<dynamic>?) ?? []),
      visibility: json["visibility"] as String? ?? "public",
      archived: json["archived"] as bool? ?? false,
      disabled: json["disabled"] as bool? ?? false,
      defaultBranch: json["default_branch"] as String? ?? "main",
    );
  }

  /// Convert DTO to domain model
  GitHubRepo toDomain() {
    return GitHubRepo(
      name: name,
      htmlUrl: htmlUrl,
      description: description?.trim() ?? "",
      stargazersCount: stargazersCount,
      forksCount: forksCount,
      updatedAt: DateTime.tryParse(updatedAt) ?? DateTime.now(),
      language: language,
      topics: topics,
      visibility: visibility,
      archived: archived,
      disabled: disabled,
      defaultBranch: defaultBranch,
    );
  }

  /// Convert to JSON for caching
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "html_url": htmlUrl,
      "description": description,
      "stargazers_count": stargazersCount,
      "forks_count": forksCount,
      "updated_at": updatedAt,
      "language": language,
      "topics": topics,
      "visibility": visibility,
      "archived": archived,
      "disabled": disabled,
      "default_branch": defaultBranch,
    };
  }

  /// Create DTO from cached JSON
  factory GitHubRepoDto.fromCachedJson(Map<String, dynamic> json) {
    return GitHubRepoDto(
      name: json["name"] as String? ?? "",
      htmlUrl: json["html_url"] as String? ?? "",
      description: json["description"] as String?,
      stargazersCount: json["stargazers_count"] as int? ?? 0,
      forksCount: json["forks_count"] as int? ?? 0,
      updatedAt: json["updated_at"] as String? ?? "",
      language: json["language"] as String?,
      topics: List<String>.from((json["topics"] as List<dynamic>?) ?? []),
      visibility: json["visibility"] as String? ?? "public",
      archived: json["archived"] as bool? ?? false,
      disabled: json["disabled"] as bool? ?? false,
      defaultBranch: json["default_branch"] as String? ?? "main",
    );
  }
}
