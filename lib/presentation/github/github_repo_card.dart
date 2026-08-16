import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/github_repo_model.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:intl/intl.dart";
import "package:url_launcher/url_launcher.dart";

/// Card presenting a single GitHub repository.
class GitHubRepoCard extends StatelessWidget {
  /// [GitHubRepoCard] constructor.
  const GitHubRepoCard({
    super.key,
    required this.repo,
    required this.username,
  });

  final GitHubRepoModel repo;
  final String username;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
        border: Border.all(color: tokens.color.outline.withValues(alpha: 0.2)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
        onTap: () => launchUrl(Uri.parse(repo.htmlUrl), mode: LaunchMode.externalApplication),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  FaIcon(FontAwesomeIcons.github, size: 18, color: tokens.color.primary),
                  SizedBox(width: tokens.spacing.sm),
                  Expanded(
                    child: Text(
                      repo.name,
                      style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              if (repo.description != null && repo.description!.isNotEmpty) ...[
                SizedBox(height: tokens.spacing.sm),
                Text(
                  repo.description!,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: tokens.text.bodyMedium?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.75)),
                ),
              ],
              SizedBox(height: tokens.spacing.md),
              Wrap(
                spacing: tokens.spacing.xs,
                runSpacing: tokens.spacing.xs,
                children: [
                  if (repo.language != null) _MetaChip(icon: FontAwesomeIcons.code, label: repo.language!, tokens: tokens),
                  _MetaChip(icon: FontAwesomeIcons.star, label: "${repo.stargazersCount}", tokens: tokens),
                  _MetaChip(icon: FontAwesomeIcons.codeFork, label: "${repo.forksCount}", tokens: tokens),
                ],
              ),
              if (repo.topics.isNotEmpty) ...[
                SizedBox(height: tokens.spacing.sm),
                Wrap(
                  spacing: tokens.spacing.xs,
                  runSpacing: tokens.spacing.xs,
                  children: repo.topics
                      .take(4)
                      .map(
                        (topic) => Chip(
                          label: Text(topic),
                          visualDensity: VisualDensity.compact,
                          labelStyle: tokens.chip.labelStyle,
                        ),
                      )
                      .toList(),
                ),
              ],
              if (repo.updatedAt != null) ...[
                SizedBox(height: tokens.spacing.sm),
                Text(
                  "Updated ${DateFormat.yMMMd().format(repo.updatedAt!)}",
                  style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  const _MetaChip({
    required this.icon,
    required this.label,
    required this.tokens,
  });

  final FaIconData icon;
  final String label;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(icon, size: 12, color: tokens.color.onSurfaceWithOpacity(0.7)),
        SizedBox(width: tokens.spacing.xs),
        Text(label, style: tokens.text.bodySmall),
      ],
    );
  }
}
