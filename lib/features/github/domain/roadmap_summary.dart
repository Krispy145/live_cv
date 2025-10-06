import "package:dart_mappable/dart_mappable.dart";

part "roadmap_summary.mapper.dart";

/// Summary data for the AI + Cybersecurity Roadmap
@MappableClass()
class RoadmapSummary with RoadmapSummaryMappable {
  final DateTime updated;
  final String? current;
  final String? next;
  final String? then_;
  final DateTime? securityPrepStart;

  final int learning;
  final int projects;
  final int backend;
  final int flutter;
  final int certifications;

  final String repoUrl;
  final String readmeUrl;
  final RoadmapMilestone? nextMilestone;

  const RoadmapSummary({
    required this.updated,
    this.current,
    this.next,
    this.then_,
    this.securityPrepStart,
    this.learning = 0,
    this.projects = 0,
    this.backend = 0,
    this.flutter = 0,
    this.certifications = 0,
    required this.repoUrl,
    required this.readmeUrl,
    this.nextMilestone,
  });

  /// Create RoadmapSummary from manifest JSON
  factory RoadmapSummary.fromManifest(Map<String, dynamic> manifest, String username) {
    DateTime parseDate(String dateStr) {
      // Try dd/MM/yyyy format first, then fall back to ISO format
      if (dateStr.contains("/")) {
        final parts = dateStr.split("/");
        if (parts.length == 3) {
          return DateTime(
            int.parse(parts[2]), // year
            int.parse(parts[1]), // month
            int.parse(parts[0]), // day
          );
        }
      }
      return DateTime.parse(dateStr);
    }

    DateTime? parseOptionalDate(dynamic value) {
      if (value is String && value.isNotEmpty) {
        try {
          return parseDate(value);
        } catch (e) {
          return null;
        }
      }
      return null;
    }

    // Find the next milestone with the soonest due date
    RoadmapMilestone? nextMilestone;
    final milestones = manifest["milestones"] as Map<String, dynamic>? ?? {};

    DateTime? bestDue;
    String? bestTitle;

    for (final phase in milestones.values) {
      if (phase is Map<String, dynamic>) {
        final pending = phase["pending"] as List<dynamic>? ?? [];
        for (final item in pending) {
          if (item is Map<String, dynamic>) {
            final due = parseOptionalDate(item["due"]);
            if (due != null && (bestDue == null || due.isBefore(bestDue))) {
              bestDue = due;
              bestTitle = item["title"] as String? ?? "Milestone";
            }
          }
        }
      }
    }

    if (bestTitle != null) {
      nextMilestone = RoadmapMilestone(title: bestTitle, due: bestDue);
    }

    final focus = manifest["focus"] as Map<String, dynamic>? ?? {};
    final progress = manifest["progress"] as Map<String, dynamic>? ?? {};

    return RoadmapSummary(
      updated: parseDate(manifest["updated"] as String),
      current: focus["current"] as String?,
      next: focus["next"] as String?,
      then_: focus["then"] as String?,
      securityPrepStart: parseOptionalDate(focus["security_prep_start"]),
      learning: (progress["learning"] as int?) ?? 0,
      projects: (progress["projects"] as int?) ?? 0,
      backend: (progress["backend"] as int?) ?? 0,
      flutter: (progress["flutter"] as int?) ?? 0,
      certifications: (progress["certifications"] as int?) ?? 0,
      repoUrl: "https://github.com/$username/ai-cyber-security-roadmap",
      readmeUrl: "https://github.com/$username/ai-cyber-security-roadmap#readme",
      nextMilestone: nextMilestone,
    );
  }
}

/// Represents a roadmap milestone
@MappableClass()
class RoadmapMilestone with RoadmapMilestoneMappable {
  final String title;
  final DateTime? due;

  const RoadmapMilestone({
    required this.title,
    this.due,
  });
}
