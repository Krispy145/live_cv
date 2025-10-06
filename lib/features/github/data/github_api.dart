import "dart:convert";

import "package:cv_app/utils/loggers.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:utilities/logger/logger.dart";

/// GitHub API client for fetching repository data
class GitHubApi {
  final Dio _dio;

  GitHubApi({String? githubToken})
      : _dio = Dio(
          BaseOptions(
            baseUrl: "https://api.github.com",
            headers: {
              "Accept": "application/vnd.github+json",
              "X-GitHub-Api-Version": "2022-11-28",
              if (githubToken != null && githubToken.isNotEmpty) "Authorization": "Bearer $githubToken",
            },
          ),
        );

  /// Get the Dio instance for external use
  Dio get dio => _dio;

  /// Fetch public repositories for a user
  Future<List<Map<String, dynamic>>> getUserRepositories(String username) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        "/users/$username/repos",
        queryParameters: {
          "per_page": 100,
          "sort": "updated",
        },
      );

      if (response.statusCode == 200) {
        return List<Map<String, dynamic>>.from(response.data!);
      } else if (response.statusCode == 403) {
        // Check if rate limited
        final remaining = response.headers.value("x-ratelimit-remaining");
        if (remaining == "0") {
          throw GitHubRateLimitException();
        }
        throw GitHubApiException("API request failed: ${response.statusCode}");
      } else {
        throw GitHubApiException("API request failed: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        final remaining = e.response?.headers.value("x-ratelimit-remaining");
        if (remaining == "0") {
          throw GitHubRateLimitException();
        }
      }
      throw GitHubApiException("Network error: ${e.message}");
    } catch (e) {
      throw GitHubApiException("Unexpected error: $e");
    }
  }

  /// Fetch topics for a specific repository
  Future<List<String>> getRepositoryTopics(String owner, String repo) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>("/repos/$owner/$repo/topics");

      if (response.statusCode == 200) {
        final data = response.data!;
        return List<String>.from((data["names"] as List<dynamic>?) ?? []);
      } else {
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.print(
          "Failed to fetch topics for $owner/$repo: $e",
          [CVAppLoggers.github],
          type: LoggerType.error,
        );
      }
      return [];
    }
  }

  /// Fetch manifest.json from a repository
  Future<Map<String, dynamic>?> getRepositoryManifest(String owner, String repo) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>("/repos/$owner/$repo/contents/manifest.json");

      if (response.statusCode == 200) {
        final data = response.data!;
        final content = data["content"] as String?;
        if (content != null) {
          try {
            // Clean the base64 content (remove newlines and whitespace)
            final cleanContent = content.replaceAll(RegExp(r"\s+"), "");
            // Decode base64 content
            final decodedBytes = base64Decode(cleanContent);
            final decodedString = utf8.decode(decodedBytes);
            return jsonDecode(decodedString) as Map<String, dynamic>;
          } catch (decodeError) {
            if (kDebugMode) {
              AppLogger.print(
                "Failed to decode manifest content for $owner/$repo: $decodeError",
                [CVAppLoggers.github],
                type: LoggerType.error,
              );
              AppLogger.print(
                "Content preview: ${content.substring(0, content.length > 100 ? 100 : content.length)}",
                [CVAppLoggers.github],
              );
            }
            return null;
          }
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        AppLogger.print(
          "Failed to fetch manifest for $owner/$repo: $e",
          [CVAppLoggers.github],
          type: LoggerType.error,
        );
      }
      return null;
    }
  }
}

/// Exception thrown when GitHub API rate limit is exceeded
class GitHubRateLimitException implements Exception {
  @override
  String toString() => "GitHub API rate limit exceeded. Please set a Personal Access Token to increase limits.";
}

/// General GitHub API exception
class GitHubApiException implements Exception {
  final String message;

  GitHubApiException(this.message);

  @override
  String toString() => "GitHub API Error: $message";
}
