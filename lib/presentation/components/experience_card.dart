import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:flutter/material.dart";

/// Professional experience card matching the deployed CV layout.
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
    return _ProfileCard(
      timelineModel: timelineModel,
      isLast: isLast,
      icon: Icons.work_outline,
    );
  }
}

/// Education / certification card matching the deployed CV layout.
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
    return _ProfileCard(
      timelineModel: timelineModel,
      isLast: isLast,
      icon: Icons.school_outlined,
    );
  }
}

class _ProfileCard extends StatelessWidget {
  const _ProfileCard({
    required this.timelineModel,
    required this.isLast,
    required this.icon,
  });

  final TimelineModel timelineModel;
  final bool isLast;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : tokens.spacing.lg),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(tokens.card.borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: tokens.color.surface,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: tokens.color.onSurfaceWithOpacity(0.7), size: 22),
                  ),
                  SizedBox(width: tokens.spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          timelineModel.title,
                          style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        if (timelineModel.dateRange.isNotEmpty) ...[
                          SizedBox(height: tokens.spacing.xs),
                          Text(
                            timelineModel.dateRange,
                            style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.65)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (timelineModel.description != null) ...[
                SizedBox(height: tokens.spacing.md),
                Text(
                  timelineModel.description!,
                  style: tokens.text.bodyMedium?.copyWith(
                    color: tokens.color.onSurfaceWithOpacity(0.8),
                    height: 1.45,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
