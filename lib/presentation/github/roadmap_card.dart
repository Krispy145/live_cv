import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/repositories/github/roadmap_summary.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:url_launcher/url_launcher.dart";

/// Card presenting the public AI + cybersecurity roadmap.
class RoadmapCard extends StatelessWidget {
  /// [RoadmapCard] constructor.
  const RoadmapCard({
    super.key,
    required this.data,
    required this.username,
  });

  final RoadmapSummary data;
  final String username;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final repoUrl = "https://github.com/$username/ai-cyber-security-roadmap";

    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
        border: Border.all(color: tokens.color.outline.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timeline, color: tokens.color.primary),
                SizedBox(width: tokens.spacing.sm),
                Expanded(
                  child: Text(
                    data.title ?? "AI + Cybersecurity Roadmap",
                    style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                if (data.status != null)
                  Chip(
                    label: Text(data.status!),
                    visualDensity: VisualDensity.compact,
                    labelStyle: tokens.chip.labelStyle,
                  ),
              ],
            ),
            if (data.focus != null) ...[
              SizedBox(height: tokens.spacing.md),
              Text("Current focus", style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.7))),
              SizedBox(height: tokens.spacing.xs),
              Text(data.focus!, style: tokens.text.bodyLarge),
            ],
            if (data.lastUpdated != null) ...[
              SizedBox(height: tokens.spacing.sm),
              Text(
                "Last updated ${data.lastUpdated}",
                style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6)),
              ),
            ],
            if (data.milestones.isNotEmpty) ...[
              SizedBox(height: tokens.spacing.lg),
              ...data.milestones.take(8).map(
                    (milestone) => Padding(
                      padding: EdgeInsets.only(bottom: tokens.spacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            _statusIcon(milestone.status),
                            size: 16,
                            color: tokens.color.primary,
                          ),
                          SizedBox(width: tokens.spacing.sm),
                          Expanded(
                            child: Text(
                              [
                                milestone.title,
                                if (milestone.targetDate != null) "· ${milestone.targetDate}",
                              ].join(" "),
                              style: tokens.text.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
            ],
            SizedBox(height: tokens.spacing.md),
            TextButton.icon(
              onPressed: () => launchUrl(Uri.parse(repoUrl), mode: LaunchMode.externalApplication),
              icon: const FaIcon(FontAwesomeIcons.github, size: 16),
              label: const Text("View roadmap on GitHub"),
            ),
          ],
        ),
      ),
    );
  }

  IconData _statusIcon(String? status) {
    final normalized = status?.toLowerCase() ?? "";
    if (normalized.contains("done") || normalized.contains("complete")) {
      return Icons.check_circle;
    }
    if (normalized.contains("progress")) {
      return Icons.timelapse;
    }
    return Icons.radio_button_unchecked;
  }
}
