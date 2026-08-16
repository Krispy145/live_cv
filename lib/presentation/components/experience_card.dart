import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:flutter/material.dart";

/// Professional experience timeline card.
class ExperienceCard extends StatelessWidget {
  /// [ExperienceCard] constructor.
  const ExperienceCard({
    super.key,
    required this.timelineModel,
    required this.index,
    required this.isLast,
  });

  final TimelineModel timelineModel;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return _TimelineCard(
      timelineModel: timelineModel,
      isLast: isLast,
      leadingLabel: timelineModel.organization,
    );
  }
}

/// Education / certification timeline card.
class EducationCard extends StatelessWidget {
  /// [EducationCard] constructor.
  const EducationCard({
    super.key,
    required this.timelineModel,
    required this.index,
    required this.isLast,
  });

  final TimelineModel timelineModel;
  final int index;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return _TimelineCard(
      timelineModel: timelineModel,
      isLast: isLast,
      leadingLabel: timelineModel.organization,
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({
    required this.timelineModel,
    required this.isLast,
    required this.leadingLabel,
  });

  final TimelineModel timelineModel;
  final bool isLast;
  final String leadingLabel;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: tokens.color.primary,
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: tokens.color.primary.withValues(alpha: 0.3),
                  ),
                ),
            ],
          ),
          SizedBox(width: tokens.spacing.lg),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : tokens.spacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(timelineModel.title, style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  SizedBox(height: tokens.spacing.xs),
                  Text(leadingLabel, style: tokens.text.bodyMedium?.copyWith(color: tokens.color.primary)),
                  SizedBox(height: tokens.spacing.xs),
                  Text(
                    [
                      timelineModel.dateRange,
                      if (timelineModel.location != null) timelineModel.location,
                    ].join("  ·  "),
                    style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.7)),
                  ),
                  if (timelineModel.description != null) ...[
                    SizedBox(height: tokens.spacing.sm),
                    Text(timelineModel.description!, style: tokens.text.bodyMedium),
                  ],
                  if (timelineModel.highlights.isNotEmpty) ...[
                    SizedBox(height: tokens.spacing.sm),
                    ...timelineModel.highlights.map(
                      (highlight) => Padding(
                        padding: EdgeInsets.only(bottom: tokens.spacing.xs),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("•  ", style: tokens.text.bodyMedium),
                            Expanded(child: Text(highlight, style: tokens.text.bodyMedium)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
