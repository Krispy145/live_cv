import "dart:convert";

import "package:cv_app/data/models/github_repo_model.dart";
import "package:cv_app/domain/repositories/github/readme_document.dart";
import "package:cv_app/domain/repositories/github/roadmap_summary.dart";
import "package:cv_app/utils/loggers.dart";
import "package:dio/dio.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:utilities/logger/logger.dart";

/// Fetches GitHub repositories and the public roadmap manifest.
class GitHubRepository {
  /// [GitHubRepository] constructor.
  GitHubRepository({
    Dio? dio,
    this.username = const String.fromEnvironment("GITHUB_USERNAME", defaultValue: "Krispy145"),
    this.token = const String.fromEnvironment("GITHUB_TOKEN"),
  }) : _dio = dio ?? Dio();

  static const _reposCacheKey = "github_repos_cache";
  static const _roadmapCacheKey = "github_roadmap_cache";
  static const _cacheTimestampKey = "github_cache_timestamp";
  static const _cacheTtl = Duration(minutes: 15);
  static const roadmapRepoName = "ai-cyber-security-roadmap";

  final Dio _dio;
  final String username;
  final String token;

  Map<String, dynamic> get _headers {
    final headers = <String, dynamic>{
      "Accept": "application/vnd.github+json",
      "User-Agent": "cv-app",
    };
    if (token.isNotEmpty) {
      headers["Authorization"] = "Bearer $token";
    }
    return headers;
  }

  String rawRoadmapAsset(String relativePath) {
    if (relativePath.startsWith("http")) {
      return relativePath;
    }
    return "https://raw.githubusercontent.com/$username/$roadmapRepoName/main/$relativePath";
  }

  /// Loads repositories, using cache when it is still fresh.
  Future<List<GitHubRepoModel>> getRepositories({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_reposCacheKey);
    final timestamp = DateTime.tryParse(prefs.getString(_cacheTimestampKey) ?? "");
    final isFresh = timestamp != null && DateTime.now().difference(timestamp) < _cacheTtl;

    if (!forceRefresh && cached != null && isFresh) {
      return _decodeRepos(cached);
    }

    try {
      final response = await _dio.get<List<dynamic>>(
        "https://api.github.com/users/$username/repos",
        queryParameters: {
          "per_page": 100,
          "sort": "updated",
          "type": "owner",
        },
        options: Options(headers: _headers),
      );
      final repos = (response.data ?? const [])
          .whereType<Map>()
          .map((item) => GitHubRepoModel.fromMap(Map<String, dynamic>.from(item)))
          .where((repo) => !repo.fork && !repo.archived)
          .toList();
      await prefs.setString(_reposCacheKey, jsonEncode(repos.map((repo) => repo.toMap()).toList()));
      await prefs.setString(_cacheTimestampKey, DateTime.now().toIso8601String());
      return repos;
    } catch (error) {
      AppLogger.print("Failed to load GitHub repos: $error", [CVAppLoggers.github], type: LoggerType.error);
      if (cached != null) {
        return _decodeRepos(cached);
      }
      rethrow;
    }
  }

  /// Loads the roadmap manifest from GitHub, with a cached fallback.
  Future<RoadmapSummary?> getRoadmapSummary({bool forceRefresh = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final cached = prefs.getString(_roadmapCacheKey);

    try {
      final response = await _dio.get<dynamic>(
        "https://raw.githubusercontent.com/$username/$roadmapRepoName/main/manifest.json",
        options: Options(headers: _headers),
      );
      final data = _asJsonMap(response.data);
      if (data == null) {
        return cached == null ? null : RoadmapSummary.fromMap(jsonDecode(cached) as Map<String, dynamic>);
      }
      await prefs.setString(_roadmapCacheKey, jsonEncode(data));
      var summary = RoadmapSummary.fromMap(data);
      final readme = await getReadme(roadmapRepoName);
      if (readme != null) {
        summary = summary.copyWith(readme: readme);
      }
      return summary;
    } catch (error) {
      AppLogger.print("Failed to load roadmap manifest: $error", [CVAppLoggers.github], type: LoggerType.warning);
      if (cached != null) {
        return RoadmapSummary.fromMap(jsonDecode(cached) as Map<String, dynamic>);
      }
      return null;
    }
  }

  /// Fetches and parses a repository README.
  Future<ReadmeDocument?> getReadme(String repoName) async {
    try {
      final response = await _dio.get<String>(
        "https://raw.githubusercontent.com/$username/$repoName/main/README.md",
        options: Options(headers: _headers, responseType: ResponseType.plain),
      );
      final markdown = response.data;
      if (markdown == null || markdown.trim().isEmpty) {
        return null;
      }
      return ReadmeDocument.parse(markdown);
    } catch (error) {
      AppLogger.print("Failed to load README for $repoName: $error", [CVAppLoggers.github], type: LoggerType.warning);
      return null;
    }
  }

  /// Combines GitHub API repos with roadmap manifest metadata (covers, status, blurbs).
  List<GitHubRepoModel> mergeWithRoadmap(List<GitHubRepoModel> githubRepos, RoadmapSummary? roadmap) {
    if (roadmap == null || roadmap.repositories.isEmpty) {
      return githubRepos;
    }
    final byName = {for (final repo in githubRepos) repo.name: repo};
    return roadmap.repositories.map((tracked) {
      final existing = byName[tracked.name];
      final cover = tracked.coverPath == null ? null : rawRoadmapAsset(tracked.coverPath!);
      final thumb = tracked.thumbnailPath == null ? null : rawRoadmapAsset(tracked.thumbnailPath!);
      if (existing == null) {
        return GitHubRepoModel(
          id: tracked.name.hashCode,
          name: tracked.name,
          fullName: "$username/${tracked.name}",
          htmlUrl: tracked.url ?? "https://github.com/$username/${tracked.name}",
          description: tracked.description,
          shortDescription: tracked.shortDescription,
          topics: tracked.topics,
          status: tracked.status,
          coverUrl: cover,
          thumbnailUrl: thumb,
          targetDate: tracked.target,
        );
      }
      return existing.copyWith(
        description: tracked.description ?? existing.description,
        shortDescription: tracked.shortDescription ?? existing.shortDescription,
        topics: tracked.topics.isNotEmpty ? tracked.topics : existing.topics,
        status: tracked.status ?? existing.status,
        coverUrl: cover ?? existing.coverUrl,
        thumbnailUrl: thumb ?? existing.thumbnailUrl,
        targetDate: tracked.target ?? existing.targetDate,
      );
    }).toList();
  }

  List<GitHubRepoModel> _decodeRepos(String cached) {
    final decoded = jsonDecode(cached);
    if (decoded is! List) {
      return const [];
    }
    return decoded.whereType<Map>().map((item) => GitHubRepoModel.fromMap(Map<String, dynamic>.from(item))).toList();
  }

  Map<String, dynamic>? _asJsonMap(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is String && data.trim().isNotEmpty) {
      final decoded = jsonDecode(data);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
    }
    return null;
  }
}
