import "package:cv_app/features/github/domain/roadmap_summary.dart";
import "package:cv_package/core/theme/theme_tokens.dart";
import "package:cv_package/core/utils/date_formatter.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

/// Special card widget for displaying the AI + Cybersecurity Roadmap
class RoadmapCard extends StatelessWidget {
  final RoadmapSummary data;
  final VoidCallback? onViewMilestones;

  const RoadmapCard({
    super.key,
    required this.data,
    this.onViewMilestones,
  });

  Widget _pill(String text, {Color? color, required ThemeTokens tokens}) {
    return Container(
      padding: tokens.chip.padding,
      decoration: BoxDecoration(
        color: color?.withOpacity(0.12) ?? tokens.color.primaryWithOpacity(0.12),
        borderRadius: BorderRadius.circular(tokens.chip.borderRadius),
      ),
      child: Text(
        text,
        style: tokens.chip.labelStyle,
      ),
    );
  }

  Widget _progressMeter(String label, int percentage, ThemeTokens tokens) {
    final clampedPercentage = percentage.clamp(0, 100);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: tokens.text.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "$clampedPercentage%",
              style: tokens.text.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: tokens.color.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: tokens.spacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: clampedPercentage / 100.0,
            minHeight: 6,
            backgroundColor: tokens.color.surfaceContainerHighest,
            valueColor: AlwaysStoppedAnimation<Color>(tokens.color.primary),
          ),
        ),
      ],
    );
  }

  Future<void> _openUrl(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Could not open $url")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(tokens.card.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              tokens.color.primaryContainer.withOpacity(0.1),
              tokens.color.secondaryContainer.withOpacity(0.05),
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AI + Cybersecurity Roadmap",
                          style: tokens.text.titleLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: tokens.color.primary,
                          ),
                        ),
                        SizedBox(height: tokens.spacing.xs),
                        Text(
                          "Last updated: ${DateFormatter.formatDate(data.updated)}",
                          style: tokens.text.metaText,
                        ),
                      ],
                    ),
                  ),
                  _pill("Roadmap", color: tokens.color.secondary, tokens: tokens),
                  SizedBox(width: tokens.spacing.sm),
                  IconButton(
                    tooltip: "Open Repo",
                    onPressed: () => _openUrl(context, data.repoUrl),
                    icon: Icon(
                      Icons.open_in_new,
                      color: tokens.color.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: tokens.spacing.lg),

              // Focus lines
              if (data.current != null) ...[
                _buildFocusLine("Current", data.current!, tokens, Icons.play_circle_outline),
                SizedBox(height: tokens.spacing.sm),
              ],
              if (data.next != null) ...[
                _buildFocusLine(
                  "Next",
                  data.next!,
                  tokens,
                  Icons.schedule,
                  suffix: data.nextMilestone?.due != null ? " → ${DateFormatter.formatDate(data.nextMilestone!.due!)}" : "",
                ),
                SizedBox(height: tokens.spacing.sm),
              ],
              if (data.then_ != null) ...[
                _buildFocusLine("Then", data.then_!, tokens, Icons.timeline),
                SizedBox(height: tokens.spacing.lg),
              ],

              // Progress section
              Text(
                "Progress",
                style: tokens.text.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: tokens.spacing.md),

              // Progress meters
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 520;
                  final meters = [
                    _progressMeter("Learning", data.learning, tokens),
                    _progressMeter("Projects", data.projects, tokens),
                    _progressMeter("Backend", data.backend, tokens),
                    _progressMeter("Flutter", data.flutter, tokens),
                    _progressMeter("Certifications", data.certifications, tokens),
                  ];

                  if (isWide) {
                    return Row(
                      children: meters
                          .map(
                            (m) => Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: tokens.spacing.md),
                                child: m,
                              ),
                            ),
                          )
                          .toList(),
                    );
                  } else {
                    return Column(
                      children: meters
                          .map(
                            (m) => Padding(
                              padding: EdgeInsets.only(bottom: tokens.spacing.md),
                              child: m,
                            ),
                          )
                          .toList(),
                    );
                  }
                },
              ),

              SizedBox(height: tokens.spacing.lg),

              // Next milestone chip
              if (data.nextMilestone != null) ...[
                Wrap(
                  spacing: tokens.spacing.sm,
                  runSpacing: tokens.spacing.sm,
                  children: [
                    _pill(
                      "Next: ${data.nextMilestone!.title} · ${DateFormatter.formatDate(data.nextMilestone!.due!)}",
                      color: tokens.color.tertiary,
                      tokens: tokens,
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.xl),
              ],

              // Actions
              Wrap(
                spacing: tokens.spacing.md,
                runSpacing: tokens.spacing.sm,
                children: [
                  FilledButton.icon(
                    onPressed: () => _openUrl(context, data.readmeUrl),
                    icon: const Icon(Icons.map, size: 18),
                    label: const Text("View Roadmap"),
                    style: tokens.button.filled,
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _openUrl(context, data.repoUrl),
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: const Text("Open Repo"),
                    style: tokens.button.outlined,
                  ),
                  if (onViewMilestones != null)
                    TextButton.icon(
                      onPressed: onViewMilestones,
                      icon: const Icon(Icons.timeline, size: 18),
                      label: const Text("See Milestones"),
                      style: tokens.button.text,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFocusLine(String label, String content, ThemeTokens tokens, IconData icon, {String suffix = ""}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 16,
          color: tokens.color.primaryWithOpacity(0.7),
        ),
        SizedBox(width: tokens.spacing.sm),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "$label: ",
                  style: tokens.text.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: tokens.color.primary,
                  ),
                ),
                TextSpan(
                  text: content,
                  style: tokens.text.bodyMedium,
                ),
                if (suffix.isNotEmpty)
                  TextSpan(
                    text: suffix,
                    style: tokens.text.bodyMedium?.copyWith(
                      color: tokens.color.onSurfaceWithOpacity(0.7),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
