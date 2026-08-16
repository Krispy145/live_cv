import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/github_repo_model.dart";
import "package:cv_app/domain/repositories/github/roadmap_summary.dart";
import "package:cv_app/presentation/github/readme_view.dart";
import "package:flutter/material.dart";

/// Interactive roadmap section matching the deployed CV.
class RoadmapCard extends StatefulWidget {
  /// [RoadmapCard] constructor.
  const RoadmapCard({
    super.key,
    required this.data,
    required this.username,
  });

  final RoadmapSummary data;
  final String username;

  @override
  State<RoadmapCard> createState() => _RoadmapCardState();
}

class _RoadmapCardState extends State<RoadmapCard> {
  bool _showReadme = true;
  bool _showMilestones = false;
  String _milestoneFilter = "in_progress";

  RoadmapSummary get data => widget.data;

  static const _progressLabels = <String, String>{
    "learning": "Learning",
    "backendProjects": "Backend Projects",
    "flutterProjects": "Flutter Projects",
    "reactProjects": "React Projects",
    "reactNativeProjects": "React Native Projects",
    "certifications": "Certifications",
  };

  List<RoadmapMilestone> get _filteredMilestones {
    final milestones = data.milestones;
    switch (_milestoneFilter) {
      case "recent":
        return milestones.where((item) => item.isDone).toList();
      case "in_progress":
        return milestones.where((item) => item.isInProgress).toList();
      default:
        return milestones.where((item) => item.category == _milestoneFilter).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 1100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(tokens),
          SizedBox(height: tokens.spacing.lg),
          _buildFocus(tokens),
          if (data.progress.isNotEmpty) ...[
            SizedBox(height: tokens.spacing.xl),
            Text("Progress", style: tokens.text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: tokens.spacing.md),
            _buildProgress(tokens),
          ],
          SizedBox(height: tokens.spacing.xl),
          Wrap(
            spacing: tokens.spacing.md,
            runSpacing: tokens.spacing.sm,
            children: [
              FilledButton.icon(
                onPressed: () => setState(() => _showReadme = !_showReadme),
                icon: Icon(_showReadme ? Icons.expand_less : Icons.expand_more, size: 18),
                label: Text(_showReadme ? "Hide Roadmap" : "View Roadmap"),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _showMilestones = !_showMilestones),
                icon: Icon(_showMilestones ? Icons.expand_less : Icons.expand_more, size: 18),
                label: Text(_showMilestones ? "Hide Milestones" : "View Milestones"),
              ),
            ],
          ),
          if (_showReadme) ...[
            SizedBox(height: tokens.spacing.lg),
            _buildReadmeCard(tokens),
          ],
          if (_showMilestones) ...[
            SizedBox(height: tokens.spacing.xl),
            _buildMilestones(tokens),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(ThemeTokens tokens) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: data.lastUpdated == null
              ? const SizedBox.shrink()
              : Text(
                  "Last updated: ${data.lastUpdated}",
                  style: tokens.text.bodyMedium?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6)),
                ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: tokens.color.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text("Roadmap", style: tokens.text.bodySmall),
        ),
      ],
    );
  }

  Widget _buildFocus(ThemeTokens tokens) {
    final rows = <(IconData, String, String?)>[
      (Icons.play_circle_outline, "Current", data.focus.current),
      (Icons.schedule, "Next", data.focus.next),
      (Icons.trending_up, "Then", data.focus.then),
    ].where((row) => row.$3 != null).toList();

    return Column(
      children: rows
          .map(
            (row) => Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.sm),
              child: Row(
                children: [
                  Icon(row.$1, size: 18, color: tokens.color.primary),
                  SizedBox(width: tokens.spacing.sm),
                  Text("${row.$2}: ", style: tokens.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  Expanded(child: Text(row.$3!, style: tokens.text.bodyMedium)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildProgress(ThemeTokens tokens) {
    final entries = _progressLabels.entries.where((entry) => data.progress.containsKey(entry.key)).toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 720;
        final children = entries
            .map(
              (entry) => _ProgressMeter(
                label: entry.value,
                percent: data.progress[entry.key] ?? 0,
                tokens: tokens,
              ),
            )
            .toList();
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children.map((child) => Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 6), child: child))).toList(),
          );
        }
        return Wrap(
          spacing: tokens.spacing.lg,
          runSpacing: tokens.spacing.md,
          children: children.map((child) => SizedBox(width: 160, child: child)).toList(),
        );
      },
    );
  }

  Widget _buildReadmeCard(ThemeTokens tokens) {
    final document = data.readme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
      ),
      child: Padding(
        padding: EdgeInsets.all(tokens.spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Roadmap README", style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            SizedBox(height: tokens.spacing.md),
            if (document != null)
              ReadmeView(document: document)
            else ...[
              Text(data.displayTitle, style: tokens.text.titleLarge?.copyWith(color: tokens.color.primary)),
              if (data.focus.pathSummary.isNotEmpty) ...[
                SizedBox(height: tokens.spacing.sm),
                Text(data.focus.pathSummary, style: tokens.text.bodyMedium),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMilestones(ThemeTokens tokens) {
    final filters = <(String, String)>[
      ("recent", "Recently Completed"),
      ("in_progress", "In Progress"),
      ...data.categories.take(4).map((category) => (category.name, category.name)),
    ];
    final items = _filteredMilestones;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text("Milestones", style: tokens.text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const Spacer(),
            Text("${items.length} items", style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6))),
          ],
        ),
        SizedBox(height: tokens.spacing.md),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: filters
                .map(
                  (filter) => Padding(
                    padding: EdgeInsets.only(right: tokens.spacing.sm),
                    child: FilterChip(
                      selected: _milestoneFilter == filter.$1,
                      showCheckmark: true,
                      label: Text(filter.$2),
                      onSelected: (_) => setState(() => _milestoneFilter = filter.$1),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        SizedBox(height: tokens.spacing.md),
        ...items.map((milestone) => _MilestoneTile(milestone: milestone, tokens: tokens)),
      ],
    );
  }
}

class _ProgressMeter extends StatelessWidget {
  const _ProgressMeter({
    required this.label,
    required this.percent,
    required this.tokens,
  });

  final String label;
  final int percent;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: tokens.text.bodySmall?.copyWith(fontWeight: FontWeight.w600))),
            Text("$percent%", style: tokens.text.bodySmall),
          ],
        ),
        SizedBox(height: tokens.spacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (percent.clamp(0, 100)) / 100,
            minHeight: 6,
            backgroundColor: tokens.color.onSurface.withValues(alpha: 0.12),
            color: tokens.color.primary,
          ),
        ),
      ],
    );
  }
}

class _MilestoneTile extends StatelessWidget {
  const _MilestoneTile({required this.milestone, required this.tokens});

  final RoadmapMilestone milestone;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacing.sm),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(tokens.card.borderRadius),
        ),
        child: Padding(
          padding: EdgeInsets.all(tokens.spacing.md),
          child: Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: tokens.color.primary,
                child: Icon(
                  milestone.isDone ? Icons.check : Icons.play_arrow,
                  color: tokens.color.onPrimary,
                  size: 18,
                ),
              ),
              SizedBox(width: tokens.spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(milestone.title, style: tokens.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                    if (milestone.repo != null) ...[
                      SizedBox(height: tokens.spacing.xs),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: tokens.color.surface,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(milestone.repo!, style: tokens.text.bodySmall),
                      ),
                    ],
                    if (milestone.displayDate != null) ...[
                      SizedBox(height: tokens.spacing.xs),
                      Row(
                        children: [
                          Icon(Icons.schedule, size: 14, color: tokens.color.onSurfaceWithOpacity(0.55)),
                          SizedBox(width: tokens.spacing.xs),
                          Text(
                            milestone.displayDate!,
                            style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6)),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
