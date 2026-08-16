import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/github_repo_model.dart";
import "package:cv_app/presentation/github/repo_details_dialog.dart";
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
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
        onTap: () => showRepoDetailsDialog(context, repo: repo, username: username),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CoverImage(repo: repo, height: 120, tokens: tokens),
            Padding(
              padding: EdgeInsets.all(tokens.spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          repo.name,
                          style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _StatusBadge(label: repo.statusLabel, active: repo.isActive, tokens: tokens),
                    ],
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  Row(
                    children: [
                      FaIcon(FontAwesomeIcons.star, size: 12, color: tokens.color.onSurfaceWithOpacity(0.7)),
                      SizedBox(width: tokens.spacing.xs),
                      Text("${repo.stargazersCount}", style: tokens.text.bodySmall),
                      SizedBox(width: tokens.spacing.md),
                      FaIcon(FontAwesomeIcons.codeFork, size: 12, color: tokens.color.onSurfaceWithOpacity(0.7)),
                      SizedBox(width: tokens.spacing.xs),
                      Text("${repo.forksCount}", style: tokens.text.bodySmall),
                      const Spacer(),
                      if (repo.language != null) ...[
                        Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(color: languageColor(repo.language), shape: BoxShape.circle),
                        ),
                        SizedBox(width: tokens.spacing.xs),
                        Text(repo.language!, style: tokens.text.bodySmall),
                      ],
                    ],
                  ),
                  if (repo.cardDescription.isNotEmpty) ...[
                    SizedBox(height: tokens.spacing.sm),
                    Text(
                      repo.cardDescription,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.75), height: 1.4),
                    ),
                  ],
                  if (repo.topics.isNotEmpty) ...[
                    SizedBox(height: tokens.spacing.sm),
                    Wrap(
                      spacing: tokens.spacing.xs,
                      runSpacing: tokens.spacing.xs,
                      children: repo.topics.take(4).map((topic) => _TopicChip(label: topic, tokens: tokens)).toList(),
                    ),
                  ],
                  SizedBox(height: tokens.spacing.md),
                  Row(
                    children: [
                      if (repo.updatedAt != null)
                        Expanded(
                          child: Text(
                            "Updated ${DateFormat("dd/MM/yyyy").format(repo.updatedAt!.toLocal())}",
                            style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6)),
                          ),
                        )
                      else
                        const Spacer(),
                      OutlinedButton(
                        onPressed: () => launchUrl(Uri.parse(repo.htmlUrl), mode: LaunchMode.externalApplication),
                        style: OutlinedButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: tokens.color.onSurface,
                          side: BorderSide(color: tokens.color.onSurface.withValues(alpha: 0.35)),
                          shape: const StadiumBorder(),
                        ),
                        child: const Text("Open Repo"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverImage extends StatelessWidget {
  const _CoverImage({required this.repo, required this.height, required this.tokens});

  final GitHubRepoModel repo;
  final double height;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final url = repo.thumbnailUrl ?? repo.coverUrl;
    return ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(tokens.card.borderRadius)),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: url == null
            ? _fallback()
            : Image.network(
                url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _fallback(),
              ),
      ),
    );
  }

  Widget _fallback() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            tokens.color.primary.withValues(alpha: 0.35),
            tokens.color.surface,
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.label, required this.active, required this.tokens});

  final String label;
  final bool active;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF3DDC84) : tokens.color.onSurfaceWithOpacity(0.6);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(active ? Icons.play_circle_fill : Icons.code, size: 14, color: color),
          const SizedBox(width: 4),
          Text(label, style: tokens.text.bodySmall?.copyWith(color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _TopicChip extends StatelessWidget {
  const _TopicChip({required this.label, required this.tokens});

  final String label;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.7))),
    );
  }
}
