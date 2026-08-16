import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/skill_model.dart";
import "package:flutter/material.dart";
import "package:utilities/helpers/tuples.dart";

/// Grouped skill chips for the landing skills section.
class SkillsBuilder extends StatelessWidget {
  /// [SkillsBuilder] constructor.
  const SkillsBuilder({
    super.key,
    required this.skills,
  });

  final List<Pair<String, List<SkillModel>>> skills;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 960),
      child: Column(
        children: [
          Wrap(
            alignment: WrapAlignment.center,
            spacing: tokens.spacing.lg,
            runSpacing: tokens.spacing.sm,
            children: SkillProficiency.values
                .map(
                  (level) => Text(
                    "${level.label} ${level.emoji}",
                    style: tokens.text.bodyMedium?.copyWith(
                      color: tokens.color.onSurfaceWithOpacity(0.75),
                    ),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: tokens.spacing.xxl),
          ...skills.map(
            (group) => Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.xl),
              child: Column(
                children: [
                  Text(
                    group.first,
                    style: tokens.text.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: tokens.color.onSurfaceWithOpacity(0.8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: tokens.spacing.md),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: tokens.spacing.sm,
                    runSpacing: tokens.spacing.sm,
                    children: group.second.map((skill) => _SkillChip(skill: skill, tokens: tokens)).toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatelessWidget {
  const _SkillChip({required this.skill, required this.tokens});

  final SkillModel skill;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: tokens.color.primary.withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        "${skill.name} ${skill.proficiency.emoji}",
        style: tokens.text.bodyMedium?.copyWith(
          color: tokens.color.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
