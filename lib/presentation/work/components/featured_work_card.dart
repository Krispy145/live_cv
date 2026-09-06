import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:cv_app/presentation/work/components/showcase_page.dart";
import "package:flutter/material.dart";
import "package:utilities/helpers/extensions/build_context.dart";

/// Selected-work row on the landing page.
class FeaturedWorkCard extends StatelessWidget {
  /// [FeaturedWorkCard] constructor.
  const FeaturedWorkCard({
    super.key,
    required this.study,
    required this.onOpen,
  });

  final CaseStudy study;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final index = study.index.toString().padLeft(2, "0");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ShowcaseRule(),
        InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: onOpen,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: tokens.spacing.lg),
            child: context.isScreenWidthGreaterThanTablet
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 11, child: _Copy(study: study, index: index, tokens: tokens, onOpen: onOpen)),
                      SizedBox(width: tokens.spacing.xl),
                      Expanded(flex: 9, child: _ShowcaseMockup(study: study)),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Copy(study: study, index: index, tokens: tokens, onOpen: onOpen),
                      SizedBox(height: tokens.spacing.lg),
                      _ShowcaseMockup(study: study, maxHeight: 200),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy({
    required this.study,
    required this.index,
    required this.tokens,
    required this.onOpen,
  });

  final CaseStudy study;
  final String index;
  final ThemeTokens tokens;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 56,
              child: Text(
                index,
                style: tokens.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: tokens.color.onSurfaceWithOpacity(0.45),
                ),
              ),
            ),
            Expanded(
              child: Text(
                study.title.toUpperCase(),
                style: tokens.text.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            if (study.index == 1)
              Text(
                "FEATURED",
                style: tokens.text.bodySmall?.copyWith(
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
          ],
        ),
        SizedBox(height: tokens.spacing.md),
        Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Text(
                  study.subtitle,
                  style: tokens.text.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    height: 1.4,
                    color: tokens.color.onSurfaceWithOpacity(0.8),
                  ),
                ),
              ),
              SizedBox(height: tokens.spacing.md),
              Wrap(
                spacing: tokens.spacing.md,
                runSpacing: tokens.spacing.xs,
                children: study.stack
                    .take(5)
                    .map(
                      (tech) => Text(
                        tech,
                        style: tokens.text.bodySmall?.copyWith(
                          color: tokens.color.onSurfaceWithOpacity(0.55),
                        ),
                      ),
                    )
                    .toList(),
              ),
              SizedBox(height: tokens.spacing.lg),
              TextButton(
                onPressed: onOpen,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  overlayColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text("View case study  →"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ShowcaseMockup extends StatelessWidget {
  const _ShowcaseMockup({
    required this.study,
    this.maxHeight = 260,
  });

  final CaseStudy study;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Image.asset(
        study.mockupAssetCandidates.first,
        fit: BoxFit.contain,
        alignment: Alignment.centerRight,
        filterQuality: FilterQuality.medium,
        errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
      ),
    );
  }
}
