import "dart:convert";

import "package:cv_app/features/github/data/description_resolver.dart";
import "package:cv_app/features/github/data/github_api.dart";
import "package:cv_app/features/github/data/github_repo_dto.dart";
import "package:cv_app/features/github/domain/github_repo.dart";
import "package:cv_app/features/github/domain/roadmap_summary.dart";
import "package:cv_app/utils/loggers.dart";
import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:utilities/logger/logger.dart";

/// Repository for managing GitHub data with caching
class GitHubRepository {
  static const String _cacheKey = "repos";
  static const Duration _cacheTtl = Duration(minutes: 15);

  final GitHubApi _api;
  final SharedPreferences _prefs;
  final ReadmeFetcher _readmeFetcher;

  GitHubRepository({
    required GitHubApi api,
    required SharedPreferences prefs,
    required String username,
  })  : _api = api,
        _prefs = prefs,
        _readmeFetcher = ReadmeFetcher(api.dio, username: username);

  /// Get cached repositories if available and not expired
  List<GitHubRepo>? _getCachedRepos() {
    try {
      final cachedData = _prefs.getString("${_cacheKey}_data");
      final cachedTime = _prefs.getInt("${_cacheKey}_time");

      if (cachedData != null && cachedTime != null) {
        final cacheTime = DateTime.fromMillisecondsSinceEpoch(cachedTime);
        final now = DateTime.now();

        // Check if cache is still valid
        if (now.difference(cacheTime) < _cacheTtl) {
          final jsonList = jsonDecode(cachedData) as List<dynamic>;
          return jsonList.map((json) => GitHubRepoDto.fromCachedJson(json as Map<String, dynamic>).toDomain()).where((repo) => repo.isDisplayable).toList();
        }
      }
    } catch (e) {
      // If cache is corrupted, ignore it
    }
    return null;
  }

  /// Cache repositories
  Future<void> _cacheRepos(List<GitHubRepo> repos) async {
    try {
      final jsonList = repos.map((repo) {
        // Convert back to DTO for caching
        final dto = GitHubRepoDto(
          name: repo.name,
          htmlUrl: repo.htmlUrl,
          description: repo.description,
          stargazersCount: repo.stargazersCount,
          forksCount: repo.forksCount,
          updatedAt: repo.updatedAt.toIso8601String(),
          language: repo.language,
          topics: repo.topics,
          visibility: repo.visibility,
          archived: repo.archived,
          disabled: repo.disabled,
          defaultBranch: repo.defaultBranch,
        );
        return dto.toJson();
      }).toList();

      await _prefs.setString("${_cacheKey}_data", jsonEncode(jsonList));
      await _prefs.setInt("${_cacheKey}_time", DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      // If caching fails, continue without caching
    }
  }

  /// Fetch repositories with stale-while-revalidate pattern
  Future<List<GitHubRepo>> getRepositories(String username) async {
    // First, try to return cached data immediately
    final cachedRepos = _getCachedRepos();
    if (cachedRepos != null) {
      // Start background refresh
      _refreshInBackground(username);
      return cachedRepos;
    }

    // If no cache, fetch fresh data
    return _fetchFreshRepos(username);
  }

  /// Enhance repository descriptions with README excerpts
  Future<List<GitHubRepo>> getRepositoriesWithEnhancedDescriptions(String username) async {
    final repos = await getRepositories(username);

    // Enhance descriptions for repos that need it
    final enhancedRepos = <GitHubRepo>[];

    for (final repo in repos) {
      // Only fetch README if description is empty or very short
      if (repo.description.isEmpty || repo.description.length < 20) {
        try {
          final enhancedDescription = await resolveDescription(
            repoName: repo.name,
            manifestOverridesForRepo: null, // TODO: Add manifest overrides support
            apiDescription: repo.description,
            readmeFetcher: _readmeFetcher,
          );

          enhancedRepos.add(repo.copyWith(description: enhancedDescription));
        } catch (e) {
          if (kDebugMode) {
            AppLogger.print(
              "Failed to enhance description for ${repo.name}: $e",
              [CVAppLoggers.github],
              type: LoggerType.warning,
            );
          }
          enhancedRepos.add(repo);
        }
      } else {
        enhancedRepos.add(repo);
      }
    }

    return enhancedRepos;
  }

  /// Refresh repositories in background
  Future<void> _refreshInBackground(String username) async {
    try {
      await _fetchFreshRepos(username);
    } catch (e) {
      // Background refresh failed, but we still have cached data
    }
  }

  /// Fetch fresh repositories from API
  Future<List<GitHubRepo>> _fetchFreshRepos(String username) async {
    try {
      final jsonList = await _api.getUserRepositories(username);

      // Convert to domain models and filter
      final repos = jsonList.map((json) => GitHubRepoDto.fromJson(json).toDomain()).where((repo) => repo.isDisplayable).toList();

      // Cache the results
      await _cacheRepos(repos);

      return repos;
    } on GitHubRateLimitException {
      rethrow;
    } catch (e) {
      throw GitHubRepositoryException("Failed to fetch repositories: $e");
    }
  }

  /// Force refresh repositories (bypass cache)
  Future<List<GitHubRepo>> refreshRepositories(String username) async {
    return _fetchFreshRepos(username);
  }

  /// Clear cache
  Future<void> clearCache() async {
    await _prefs.remove("${_cacheKey}_data");
    await _prefs.remove("${_cacheKey}_time");
    await _prefs.remove("${_cacheKey}_roadmap");
  }

  /// Get cached roadmap data if available and not expired
  RoadmapSummary? _getCachedRoadmap() {
    try {
      final cachedData = _prefs.getString("${_cacheKey}_roadmap");
      if (cachedData != null) {
        return RoadmapSummaryMapper.fromJson(cachedData);
      }
    } catch (e) {
      // If there's an error reading cache, treat as no cache
      return null;
    }
    return null;
  }

  /// Cache roadmap data to local storage
  Future<void> _cacheRoadmap(RoadmapSummary roadmap) async {
    try {
      final json = roadmap.toJson();
      await _prefs.setString("${_cacheKey}_roadmap", json);
    } catch (e) {
      // If caching fails, continue without caching
    }
  }

  /// Fetch roadmap data from the API
  Future<RoadmapSummary?> getRoadmapData(String username) async {
    // Try cache first
    final cachedRoadmap = _getCachedRoadmap();
    if (cachedRoadmap != null) {
      // Refresh in background
      _fetchFreshRoadmap(username).then((freshRoadmap) {
        if (freshRoadmap != null) {
          _cacheRoadmap(freshRoadmap);
        }
      }).catchError((_) {
        // Handle background refresh errors silently
      });
      return cachedRoadmap;
    }

    // If no cache, fetch fresh data
    return _fetchFreshRoadmap(username);
  }

  /// Fetch fresh roadmap data from the API
  Future<RoadmapSummary?> _fetchFreshRoadmap(String username) async {
    try {
      final manifest = await _api.getRepositoryManifest(username, "ai-cyber-security-roadmap");
      if (manifest != null) {
        final roadmap = RoadmapSummary.fromManifest(manifest, username);
        await _cacheRoadmap(roadmap);
        return roadmap;
      }

      // If manifest.json doesn't exist or can't be parsed, create a fallback roadmap
      if (kDebugMode) {
        AppLogger.print(
          "No manifest.json found for $username/ai-cyber-security-roadmap, creating fallback roadmap",
          [CVAppLoggers.github],
          type: LoggerType.warning,
        );
      }

      final fallbackRoadmap = RoadmapSummary(
        updated: DateTime.now(),
        current: "Learning AI and Cybersecurity fundamentals",
        next: "Complete foundational courses",
        then_: "Start practical projects",
        learning: 25,
        projects: 10,
        backend: 5,
        flutter: 15,
        repoUrl: "https://github.com/$username/ai-cyber-security-roadmap",
        readmeUrl: "https://github.com/$username/ai-cyber-security-roadmap#readme",
        nextMilestone: const RoadmapMilestone(
          title: "Complete Python basics",
        ),
      );

      await _cacheRoadmap(fallbackRoadmap);
      return fallbackRoadmap;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.print(
          "Failed to fetch roadmap data: $e",
          [CVAppLoggers.github],
          type: LoggerType.error,
        );
      }
      return null;
    }
  }
}

/// Exception thrown by GitHub repository
class GitHubRepositoryException implements Exception {
  final String message;

  GitHubRepositoryException(this.message);

  @override
  String toString() => "GitHub Repository Error: $message";
}
