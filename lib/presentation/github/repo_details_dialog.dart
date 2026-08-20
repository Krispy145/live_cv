import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/github_repo_model.dart";
import "package:cv_app/domain/repositories/github/github.repository.dart";
import "package:cv_app/domain/repositories/github/readme_document.dart";
import "package:cv_app/presentation/github/readme_view.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:url_launcher/url_launcher.dart";

/// Opens the repository details dialog used on the original live CV.
Future<void> showRepoDetailsDialog(
  BuildContext context, {
  required GitHubRepoModel repo,
  required String username,
}) {
  return showDialog<void>(
    context: context,
    useRootNavigator: false,
    builder: (context) => RepoDetailsDialog(repo: repo, username: username),
  );
}

/// Modal presenting cover art, stats, and README for a repository.
class RepoDetailsDialog extends StatefulWidget {
  /// [RepoDetailsDialog] constructor.
  const RepoDetailsDialog({
    super.key,
    required this.repo,
    required this.username,
  });

  final GitHubRepoModel repo;
  final String username;

  @override
  State<RepoDetailsDialog> createState() => _RepoDetailsDialogState();
}

class _RepoDetailsDialogState extends State<RepoDetailsDialog> {
  late final Future<ReadmeDocument?> _readmeFuture;

  GitHubRepoModel get repo => widget.repo;
  String get username => widget.username;

  @override
  void initState() {
    super.initState();
    _readmeFuture = GitHubRepository(username: username).getReadme(
      repo.name,
      defaultBranch: repo.defaultBranch,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return Dialog(
      backgroundColor: tokens.color.surfaceContainerHighest,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640, maxHeight: 760),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 8, 8),
              child: Row(
                children: [
                  Icon(Icons.code, color: tokens.color.onSurfaceWithOpacity(0.8)),
                  SizedBox(width: tokens.spacing.sm),
                  Expanded(
                    child: Text("Repository Details", style: tokens.text.titleMedium),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(tokens.spacing.lg, 0, tokens.spacing.lg, tokens.spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _CoverBanner(repo: repo, username: username, tokens: tokens),
                    SizedBox(height: tokens.spacing.lg),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            repo.name,
                            style: tokens.text.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        _ActiveBadge(active: repo.isActive, label: repo.statusLabel, tokens: tokens),
                      ],
                    ),
                    SizedBox(height: tokens.spacing.xs),
                    Text(repo.name, style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.55))),
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
                      SizedBox(height: tokens.spacing.md),
                      Text(repo.cardDescription, style: tokens.text.bodyMedium),
                    ],
                    if (repo.topics.isNotEmpty) ...[
                      SizedBox(height: tokens.spacing.md),
                      Wrap(
                        spacing: tokens.spacing.xs,
                        runSpacing: tokens.spacing.xs,
                        children: repo.topics
                            .map(
                              (topic) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: tokens.color.surface,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(topic, style: tokens.text.bodySmall),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                    SizedBox(height: tokens.spacing.xl),
                    Center(
                      child: OutlinedButton.icon(
                        onPressed: () => launchUrl(Uri.parse(repo.htmlUrl), mode: LaunchMode.externalApplication),
                        icon: const FaIcon(FontAwesomeIcons.github, size: 16),
                        label: const Text("View on GitHub"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: tokens.color.onSurface,
                          side: BorderSide(color: tokens.color.onSurface.withValues(alpha: 0.35)),
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: tokens.spacing.md),
                    Text("README", style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 0.6)),
                    SizedBox(height: tokens.spacing.md),
                    FutureBuilder<ReadmeDocument?>(
                      future: _readmeFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState != ConnectionState.done) {
                          return Padding(
                            padding: EdgeInsets.all(tokens.spacing.xl),
                            child: Center(child: CircularProgressIndicator(color: tokens.color.primary)),
                          );
                        }
                        final document = snapshot.data;
                        if (document == null) {
                          return Text(
                            "README is not available for this repository.",
                            style: tokens.text.bodyMedium?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.7)),
                          );
                        }
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: tokens.color.surface,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(tokens.spacing.lg),
                            child: ReadmeView(document: document),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CoverBanner extends StatelessWidget {
  const _CoverBanner({
    required this.repo,
    required this.username,
    required this.tokens,
  });

  final GitHubRepoModel repo;
  final String username;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final url = repo.coverUrl ?? repo.thumbnailUrl;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 180,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (url != null) Image.network(url, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _gradient()) else _gradient(),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.15),
                    Colors.black.withValues(alpha: 0.55),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(repo.title, style: tokens.text.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w700)),
                  if (repo.cardDescription.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      repo.cardDescription,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: tokens.text.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ],
                  const Spacer(),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: repo.topics
                        .take(5)
                        .map(
                          (topic) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.white54),
                            ),
                            child: Text(
                              titleCaseTopic(topic),
                              style: tokens.text.bodySmall?.copyWith(color: Colors.white),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "github.com/$username/${repo.name}",
                      style: tokens.text.bodySmall?.copyWith(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            tokens.color.primary.withValues(alpha: 0.5),
            tokens.color.surface,
          ],
        ),
      ),
    );
  }
}

class _ActiveBadge extends StatelessWidget {
  const _ActiveBadge({required this.active, required this.label, required this.tokens});

  final bool active;
  final String label;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF3DDC84) : tokens.color.onSurfaceWithOpacity(0.6);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
