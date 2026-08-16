/// A GitHub repository card model.
class GitHubRepoModel {
  /// [GitHubRepoModel] constructor.
  const GitHubRepoModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.htmlUrl,
    this.description,
    this.language,
    this.stargazersCount = 0,
    this.forksCount = 0,
    this.topics = const [],
    this.updatedAt,
    this.homepage,
    this.fork = false,
    this.archived = false,
  });

  final int id;
  final String name;
  final String fullName;
  final String htmlUrl;
  final String? description;
  final String? language;
  final int stargazersCount;
  final int forksCount;
  final List<String> topics;
  final DateTime? updatedAt;
  final String? homepage;
  final bool fork;
  final bool archived;

  bool get isRoadmap => name == "ai-cyber-security-roadmap";

  factory GitHubRepoModel.fromMap(Map<String, dynamic> map) {
    return GitHubRepoModel(
      id: map["id"] as int? ?? 0,
      name: map["name"] as String? ?? "",
      fullName: map["full_name"] as String? ?? "",
      htmlUrl: map["html_url"] as String? ?? "",
      description: map["description"] as String?,
      language: map["language"] as String?,
      stargazersCount: map["stargazers_count"] as int? ?? 0,
      forksCount: map["forks_count"] as int? ?? 0,
      topics: (map["topics"] as List?)?.cast<String>() ?? const [],
      updatedAt: DateTime.tryParse(map["updated_at"] as String? ?? ""),
      homepage: map["homepage"] as String?,
      fork: map["fork"] as bool? ?? false,
      archived: map["archived"] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name": name,
      "full_name": fullName,
      "html_url": htmlUrl,
      "description": description,
      "language": language,
      "stargazers_count": stargazersCount,
      "forks_count": forksCount,
      "topics": topics,
      "updated_at": updatedAt?.toIso8601String(),
      "homepage": homepage,
      "fork": fork,
      "archived": archived,
    };
  }
}
