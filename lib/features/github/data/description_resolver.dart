import "dart:convert" show base64Decode, utf8;

import "package:cv_app/utils/loggers.dart";
import "package:dio/dio.dart";
import "package:flutter/foundation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:utilities/logger/logger.dart";

class ReadmeFetcher {
  ReadmeFetcher(this.dio, {required this.username, this.ttl = const Duration(days: 3)});
  final Dio dio;
  final String username;
  final Duration ttl;

  String _cacheKey(String repo) => "readme_excerpt:$username:$repo";
  String _timeKey(String repo) => "readme_excerpt_time:$username:$repo";

  Future<String?> _getCached(String repo) async {
    final prefs = await SharedPreferences.getInstance();
    final ts = prefs.getInt(_timeKey(repo));
    if (ts == null) return null;
    final isFresh = DateTime.now().millisecondsSinceEpoch - ts < ttl.inMilliseconds;
    if (!isFresh) return null;
    return prefs.getString(_cacheKey(repo));
  }

  Future<void> _setCached(String repo, String excerpt) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey(repo), excerpt);
    await prefs.setInt(_timeKey(repo), DateTime.now().millisecondsSinceEpoch);
  }

  // Minimal markdown → plain text. Keeps it small and safe.
  String _extractFirstParagraph(String md) {
    // Split paragraphs
    final paras = md.replaceAll("\r\n", "\n").split("\n\n").map((p) => p.trim()).where((p) => p.isNotEmpty).toList();

    String clean(String p) {
      // drop badges / images / headings / HTML
      final lines = p
          .split("\n")
          .where(
            (l) => !l.trim().startsWith("![") && !l.trim().startsWith("<img") && !l.trim().startsWith("#"),
          )
          .toList();
      var s = lines.join(" ").trim();
      // strip links: [text](url) -> text
      s = s.replaceAll(RegExp(r"\[([^\]]+)\]\([^)]+\)"), r"\1");
      // strip code ticks/backticks
      s = s.replaceAll("`", "");
      // collapse spaces
      s = s.replaceAll(RegExp(r"\s+"), " ").trim();
      return s;
    }

    for (final p in paras) {
      final c = clean(p);
      if (c.length >= 40) return c; // pick the first non-trivial paragraph
    }
    return paras.isNotEmpty ? clean(paras.first) : "";
  }

  /// Returns a short README excerpt or null.
  Future<String?> fetchReadmeExcerpt(String repo) async {
    // cache
    final cached = await _getCached(repo);
    if (cached != null && cached.isNotEmpty) return cached;

    try {
      final res = await dio.get<Map<String, dynamic>>(
        "/repos/$username/$repo/readme",
        options: Options(
          headers: {
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28",
          },
          validateStatus: (_) => true,
        ),
      );

      final code = res.statusCode ?? 0;
      if (code == 404) {
        if (kDebugMode) {
          AppLogger.print(
            "No README found for $username/$repo",
            [CVAppLoggers.github],
          );
        }
        return null; // no readme
      }
      if (code == 403) {
        final remaining = res.headers.value("x-ratelimit-remaining");
        final resetTime = res.headers.value("x-ratelimit-reset");
        if (kDebugMode) {
          AppLogger.print(
            "Rate limited when fetching README for $username/$repo. Remaining: $remaining, Reset: $resetTime",
            [CVAppLoggers.github],
            type: LoggerType.warning,
          );
        }
        return null; // likely rate-limited; skip
      }

      final contentB64 = res.data?["content"];
      final encoding = res.data?["encoding"];
      if (contentB64 is String && encoding == "base64") {
        try {
          // Clean the base64 string by removing whitespace
          final cleanB64 = contentB64.replaceAll(RegExp(r"\s+"), "");
          final bytes = base64Decode(cleanB64);
          final md = utf8.decode(bytes);
          final excerpt = _extractFirstParagraph(md);
          if (excerpt.isNotEmpty) {
            await _setCached(repo, excerpt);
            return excerpt;
          }
        } catch (e) {
          if (kDebugMode) {
            AppLogger.print(
              "Failed to decode README for $username/$repo: $e",
              [CVAppLoggers.github],
              type: LoggerType.error,
            );
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        AppLogger.print(
          "Failed to fetch README for $username/$repo: $e",
          [CVAppLoggers.github],
          type: LoggerType.error,
        );
      }
    }
    return null;
  }
}

/// High-level resolver used by your grid
Future<String> resolveDescription({
  required String repoName,
  required Map<String, dynamic>? manifestOverridesForRepo, // overrides[repo]
  required String? apiDescription, // GitHub repo.description
  required ReadmeFetcher readmeFetcher,
}) async {
  // 1) manifest override
  final oDesc = manifestOverridesForRepo?["description"] as String?;
  if (oDesc != null && oDesc.trim().isNotEmpty) return oDesc.trim();

  // 2) GitHub API description
  if (apiDescription != null && apiDescription.trim().isNotEmpty) {
    return apiDescription.trim();
  }

  // 3) README excerpt (lazy, cached)
  final excerpt = await readmeFetcher.fetchReadmeExcerpt(repoName);
  if (excerpt != null && excerpt.isNotEmpty) return excerpt;

  // 4) fallback
  return "No description available.";
}
