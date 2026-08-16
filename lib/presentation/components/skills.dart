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
      constraints: const BoxConstraints(maxWidth: 800),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: skills
            .map(
              (group) => Padding(
                padding: EdgeInsets.only(bottom: tokens.spacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group.first,
                      style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(height: tokens.spacing.sm),
                    Wrap(
                      spacing: tokens.spacing.sm,
                      runSpacing: tokens.spacing.sm,
                      children: group.second
                          .map(
                            (skill) => Chip(
                              label: Text(skill.name),
                              labelStyle: tokens.chip.labelStyle.copyWith(color: tokens.color.onPrimary),
                              backgroundColor: tokens.color.primary,
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
