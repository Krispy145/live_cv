import "package:cv_app/features/github/domain/github_repo.dart";
import "package:cv_package/core/theme/theme_tokens.dart";
import "package:cv_package/core/utils/date_formatter.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

/// Card widget for displaying GitHub repository information
class GitHubRepoCard extends StatefulWidget {
  final GitHubRepo repo;
  final VoidCallback? onViewRoadmap;
  final String? username; // GitHub username for building image URLs

  /// GitHubRepoCard constructor
  const GitHubRepoCard({
    super.key,
    required this.repo,
    this.onViewRoadmap,
    this.username,
  });

  @override
  State<GitHubRepoCard> createState() => _GitHubRepoCardState();
}

class _GitHubRepoCardState extends State<GitHubRepoCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _expandAnimation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _needsReadMore => widget.repo.description.length > 120;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  Widget _pill(String text, {Color? color, required ThemeTokens tokens}) {
    final backgroundColor = color ?? tokens.color.primary;
    final textColor = color != null ? tokens.color.onSurface : tokens.color.onPrimary;

    return Container(
      padding: tokens.chip.padding,
      decoration: BoxDecoration(
        color: backgroundColor.withOpacity(0.9),
        borderRadius: BorderRadius.circular(tokens.chip.borderRadius),
      ),
      child: Text(
        text,
        style: tokens.text.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _openRepository(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildCoverImage(ThemeTokens tokens) {
    if (widget.username == null) return const SizedBox.shrink();

    final imageUrl = widget.repo.buildCoverUrl(widget.username!);
    if (imageUrl == null) return const SizedBox.shrink();

    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(tokens.card.borderRadius),
        topRight: Radius.circular(tokens.card.borderRadius),
      ),
      child: Image.network(
        imageUrl,
        height: 150,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tokens.color.surfaceVariant,
                tokens.color.surfaceVariant.withOpacity(0.8),
              ],
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: tokens.color.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.code,
                    size: 32,
                    color: tokens.color.primary.withOpacity(0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "No Preview",
                  style: tokens.text.bodySmall?.copyWith(
                    color: tokens.color.onSurfaceWithOpacity(0.6),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            height: 150,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  tokens.color.surfaceVariant,
                  tokens.color.surfaceVariant.withOpacity(0.8),
                ],
              ),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    color: tokens.color.primary,
                    strokeWidth: 2,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Loading...",
                    style: tokens.text.bodySmall?.copyWith(
                      color: tokens.color.onSurfaceWithOpacity(0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDescription(ThemeTokens tokens) {
    if (widget.repo.description.isEmpty) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _expandAnimation,
      builder: (context, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.repo.description.trim(),
              maxLines: _isExpanded ? null : 3,
              overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              style: tokens.text.cardBody,
            ),
            if (_needsReadMore) ...[
              const SizedBox(height: 8),
              InkWell(
                onTap: _toggleExpansion,
                child: Text(
                  _isExpanded ? "Read Less" : "Read More",
                  style: tokens.text.bodySmall?.copyWith(
                    color: tokens.color.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final chips = <Widget>[];

    // Add language chip first
    if ((widget.repo.language ?? "").isNotEmpty) {
      chips.add(
        Chip(
          label: Text(widget.repo.language!),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: tokens.color.primary,
          labelStyle: tokens.text.bodySmall?.copyWith(
            color: tokens.color.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    // Add topic chips (limit to 6 for clean layout)
    for (final topic in widget.repo.topics.take(6)) {
      chips.add(
        Chip(
          label: Text(topic),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: tokens.color.surfaceVariant,
          labelStyle: tokens.text.bodySmall?.copyWith(
            color: tokens.color.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
    }

    return Card(
      elevation: tokens.card.elevation,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cover image
          _buildCoverImage(tokens),

          // Card content
          Padding(
            padding: tokens.card.padding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  widget.repo.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: tokens.text.cardTitle,
                                ),
                              ),
                              SizedBox(width: tokens.spacing.sm),
                              if (widget.repo.isRoadmap) _pill("Roadmap", color: Colors.amber, tokens: tokens),
                              if (widget.repo.visibility == "public") ...[
                                SizedBox(width: tokens.spacing.xs),
                                _pill("Public", tokens: tokens),
                              ],
                            ],
                          ),
                          SizedBox(height: tokens.spacing.xs),
                          Row(
                            children: [
                              Icon(Icons.star, size: 14, color: tokens.color.primary),
                              SizedBox(width: tokens.spacing.xs),
                              Text(
                                widget.repo.formattedStars,
                                style: tokens.text.bodySmall,
                              ),
                              SizedBox(width: tokens.spacing.md),
                              Icon(Icons.call_split, size: 14, color: tokens.color.primary),
                              SizedBox(width: tokens.spacing.xs),
                              Text(
                                widget.repo.formattedForks,
                                style: tokens.text.bodySmall,
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: tokens.spacing.sm),

                // Description with read more functionality
                _buildDescription(tokens),

                // Chips
                if (chips.isNotEmpty) ...[
                  SizedBox(height: tokens.spacing.sm),
                  Wrap(
                    spacing: tokens.spacing.xs,
                    runSpacing: tokens.spacing.xs,
                    children: chips,
                  ),
                ],

                // Meta + actions
                SizedBox(height: tokens.spacing.lg),
                Row(
                  children: [
                    Text(
                      "Updated ${DateFormatter.formatDate(widget.repo.updatedAt)}",
                      style: tokens.text.metaText,
                    ),
                    const Spacer(),
                    if (widget.repo.isRoadmap && widget.onViewRoadmap != null) ...[
                      FilledButton(
                        onPressed: widget.onViewRoadmap,
                        style: tokens.button.filled,
                        child: const Text("View Roadmap"),
                      ),
                      SizedBox(width: tokens.spacing.sm),
                    ],
                    OutlinedButton(
                      onPressed: () => _openRepository(widget.repo.htmlUrl),
                      style: tokens.button.outlined,
                      child: const Text("Open Repo"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
