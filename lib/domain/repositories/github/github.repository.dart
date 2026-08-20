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

  static const _reposCacheKey = "github_repos_cache_v3";
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
      "X-GitHub-Api-Version": "2022-11-28",
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
      final repos = await _fetchPublicPortfolioRepos();
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
        "https://api.github.com/repos/$username/$roadmapRepoName/contents/manifest.json",
        queryParameters: const {"ref": "main"},
        options: Options(headers: _headers),
      );
      final data = _asJsonMap(_decodeGitHubFileContent(response.data));
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

  /// Fetches and parses a repository README via the GitHub API (CORS-safe on web).
  Future<ReadmeDocument?> getReadme(String repoName, {String? defaultBranch}) async {
    try {
      final markdown = await _fetchRepoFile(
        repoName: repoName,
        path: "readme",
        ref: defaultBranch,
        isReadmeEndpoint: true,
      );
      if (markdown == null || markdown.trim().isEmpty) {
        return null;
      }
      return ReadmeDocument.parse(markdown);
    } catch (error) {
      AppLogger.print("Failed to load README for $repoName: $error", [CVAppLoggers.github], type: LoggerType.warning);
      return null;
    }
  }

  /// Enriches GitHub repos with roadmap covers, status, and blurbs when a name matches.
  List<GitHubRepoModel> mergeWithRoadmap(List<GitHubRepoModel> githubRepos, RoadmapSummary? roadmap) {
    if (roadmap == null || roadmap.repositories.isEmpty) {
      return githubRepos;
    }
    final trackedByName = {for (final tracked in roadmap.repositories) tracked.name: tracked};
    return githubRepos.map((existing) {
      final tracked = trackedByName[existing.name];
      if (tracked == null) {
        return existing;
      }
      final cover = tracked.coverPath == null ? null : rawRoadmapAsset(tracked.coverPath!);
      final thumb = tracked.thumbnailPath == null ? null : rawRoadmapAsset(tracked.thumbnailPath!);
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

  Future<List<GitHubRepoModel>> _fetchPublicPortfolioRepos() async {
    const perPage = 100;
    final repos = <GitHubRepoModel>[];
    var page = 1;
    while (true) {
      final response = await _dio.get<List<dynamic>>(
        "https://api.github.com/users/$username/repos",
        queryParameters: {
          "per_page": perPage,
          "page": page,
          "sort": "updated",
          "type": "owner",
        },
        options: Options(headers: _headers),
      );
      final rawPage = response.data ?? const [];
      repos.addAll(
        rawPage.whereType<Map<dynamic, dynamic>>().map((item) => GitHubRepoModel.fromMap(Map<String, dynamic>.from(item))).where((repo) => repo.isPortfolioRepo),
      );
      if (rawPage.length < perPage) {
        break;
      }
      page++;
    }
    return repos;
  }

  List<GitHubRepoModel> _decodeRepos(String cached) {
    final decoded = jsonDecode(cached);
    if (decoded is! List) {
      return const [];
    }
    return decoded
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => GitHubRepoModel.fromMap(Map<String, dynamic>.from(item)))
        .where((repo) => repo.isPortfolioRepo)
        .toList();
  }

  Future<String?> _fetchRepoFile({
    required String repoName,
    required String path,
    String? ref,
    bool isReadmeEndpoint = false,
  }) async {
    final encodedPath = path.split("/").map(Uri.encodeComponent).join("/");
    final url = isReadmeEndpoint
        ? "https://api.github.com/repos/$username/$repoName/readme"
        : "https://api.github.com/repos/$username/$repoName/contents/$encodedPath";
    final response = await _dio.get<dynamic>(
      url,
      queryParameters: {
        if (ref != null && ref.isNotEmpty) "ref": ref,
      },
      options: Options(headers: _headers),
    );
    return _decodeGitHubFileContent(response.data);
  }

  String? _decodeGitHubFileContent(dynamic data) {
    if (data is String) {
      final trimmed = data.trim();
      if (trimmed.isEmpty) {
        return null;
      }
      if (trimmed.startsWith("{")) {
        return _decodeGitHubFileContent(jsonDecode(trimmed));
      }
      return data;
    }
    final map = _asJsonMap(data);
    if (map == null) {
      return null;
    }
    final content = map["content"];
    if (content is! String || content.trim().isEmpty) {
      return null;
    }
    if ((map["encoding"] as String?) == "base64") {
      return utf8.decode(base64.decode(content.replaceAll(RegExp(r"\s"), "")));
    }
    return content;
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
