import "package:auto_route/auto_route.dart";
import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/showcase/showcase_catalog.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:cv_app/navigation/routes.gr.dart";
import "package:cv_app/presentation/work/components/api_playground.dart";
import "package:cv_app/presentation/work/components/architecture_diagram.dart";
import "package:cv_app/presentation/work/components/schema_diagram.dart";
import "package:cv_app/presentation/work/components/showcase_page.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

/// Full case-study page with sticky section navigation.
@RoutePage()
class CaseStudyView extends StatefulWidget {
  /// [CaseStudyView] constructor.
  const CaseStudyView({
    @PathParam("slug") required this.slug,
    super.key,
  });

  /// Case-study slug from the route.
  final String slug;

  @override
  State<CaseStudyView> createState() => _CaseStudyViewState();
}

class _CaseStudyViewState extends State<CaseStudyView> {
  CaseStudySection _section = CaseStudySection.overview;

  @override
  Widget build(BuildContext context) {
    final study = ShowcaseCatalog.bySlug(widget.slug);
    if (study == null) {
      return const ShowcasePage(
        child: Text("This case study is not in the catalog."),
      );
    }

    final tokens = ThemeTokens.of(context);
    return SingleChildScrollView(
      child: ShowcasePage(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(study: study, tokens: tokens),
            SizedBox(height: tokens.spacing.xl),
            _SectionNav(
              current: _section,
              onSelect: (section) => setState(() => _section = section),
              tokens: tokens,
            ),
            SizedBox(height: tokens.spacing.xxl),
            _SectionBody(study: study, section: _section, tokens: tokens),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.study, required this.tokens});

  final CaseStudy study;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(study.title.toUpperCase(), style: tokens.text.headlineSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
        SizedBox(height: tokens.spacing.md),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Text(
            study.subtitle,
            style: tokens.text.titleLarge?.copyWith(fontWeight: FontWeight.w400, height: 1.35),
          ),
        ),
        SizedBox(height: tokens.spacing.xl),
        Wrap(
          spacing: tokens.spacing.xxl,
          runSpacing: tokens.spacing.lg,
          children: [
            _Meta(label: "ROLE", value: study.role, tokens: tokens),
            _Meta(label: "PLATFORM", value: study.platform, tokens: tokens),
            _Meta(label: "STACK", value: study.stack.take(4).join("  ·  "), tokens: tokens),
            _Meta(label: "YEAR", value: study.year, tokens: tokens),
          ],
        ),
        SizedBox(height: tokens.spacing.xl),
        Wrap(
          spacing: tokens.spacing.sm,
          runSpacing: tokens.spacing.sm,
          children: [
            if (study.sourceVisibility == SourceVisibility.public && study.githubUrl != null)
              OutlinedButton(
                onPressed: () => _open(study.githubUrl!),
                child: const Text("GitHub"),
              )
            else
              const OutlinedButton(
                onPressed: null,
                child: Text("Private — walkthrough on request"),
              ),
            TextButton(
              onPressed: () => context.router.navigate(const EngineeringRoute()),
              child: const Text("Engineering"),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.label, required this.value, required this.tokens});

  final String label;
  final String value;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: tokens.text.bodySmall?.copyWith(letterSpacing: 1.1, fontWeight: FontWeight.w700, color: tokens.color.onSurfaceWithOpacity(0.5))),
          SizedBox(height: tokens.spacing.xs),
          Text(value, style: tokens.text.bodyMedium),
        ],
      ),
    );
  }
}

class _SectionNav extends StatelessWidget {
  const _SectionNav({
    required this.current,
    required this.onSelect,
    required this.tokens,
  });

  final CaseStudySection current;
  final ValueChanged<CaseStudySection> onSelect;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: CaseStudySection.values
            .map(
              (section) => Padding(
                padding: EdgeInsets.only(right: tokens.spacing.sm),
                child: TextButton(
                  onPressed: () => onSelect(section),
                  style: TextButton.styleFrom(
                    foregroundColor: current == section ? tokens.color.primary : tokens.color.onSurfaceWithOpacity(0.55),
                  ),
                  child: Text(
                    section.label,
                    style: TextStyle(fontWeight: current == section ? FontWeight.w700 : FontWeight.w500),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _SectionBody extends StatelessWidget {
  const _SectionBody({
    required this.study,
    required this.section,
    required this.tokens,
  });

  final CaseStudy study;
  final CaseStudySection section;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return switch (section) {
      CaseStudySection.overview => _Prose(
          tokens: tokens,
          blocks: [
            ("The challenge", study.problem),
            ("The solution", study.solution),
          ],
        ),
      CaseStudySection.product => _Prose(tokens: tokens, blocks: [("Product", study.product)]),
      CaseStudySection.architecture => ArchitectureDiagram(graph: study.architecture),
      CaseStudySection.api => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Interactive documentation",
              style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            SizedBox(height: tokens.spacing.sm),
            Text(
              "These requests are simulated from fixtures exported from the real API. Nothing is sent to a hosted backend.",
              style: tokens.text.bodyMedium?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.7)),
            ),
            SizedBox(height: tokens.spacing.xl),
            ApiPlayground(endpoints: study.endpoints),
          ],
        ),
      CaseStudySection.data => SchemaDiagram(graph: study.schema),
      CaseStudySection.infrastructure => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: study.infrastructure
              .map(
                (note) => Padding(
                  padding: EdgeInsets.only(bottom: tokens.spacing.lg),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(note.label.toUpperCase(), style: tokens.text.bodySmall?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w700)),
                      SizedBox(height: tokens.spacing.xs),
                      Text(note.detail, style: tokens.text.bodyMedium),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      CaseStudySection.engineering => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: study.decisions
              .map(
                (decision) => Padding(
                  padding: EdgeInsets.only(bottom: tokens.spacing.xl),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(decision.title, style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                      SizedBox(height: tokens.spacing.sm),
                      Text(decision.detail, style: tokens.text.bodyLarge?.copyWith(height: 1.5)),
                    ],
                  ),
                ),
              )
              .toList(),
        ),
      CaseStudySection.results => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Prose(tokens: tokens, blocks: [("Result", study.result)]),
            if (study.relatedRepos.isNotEmpty) ...[
              SizedBox(height: tokens.spacing.xxl),
              Text("Related repositories", style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              SizedBox(height: tokens.spacing.md),
              ...study.relatedRepos.map(
                (repo) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(repo.name),
                  subtitle: Text(repo.description),
                  trailing: repo.url == null ? null : const Icon(Icons.north_east, size: 16),
                  onTap: repo.url == null
                      ? null
                      : () async {
                          final uri = Uri.parse(repo.url!);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(uri, mode: LaunchMode.externalApplication);
                          }
                        },
                ),
              ),
            ],
          ],
        ),
    };
  }
}

class _Prose extends StatelessWidget {
  const _Prose({required this.tokens, required this.blocks});

  final ThemeTokens tokens;
  final List<(String, String)> blocks;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: blocks
          .map(
            (block) => Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(block.$1.toUpperCase(), style: tokens.text.bodySmall?.copyWith(letterSpacing: 1.1, fontWeight: FontWeight.w700)),
                  SizedBox(height: tokens.spacing.sm),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Text(block.$2, style: tokens.text.bodyLarge?.copyWith(height: 1.55)),
                  ),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
