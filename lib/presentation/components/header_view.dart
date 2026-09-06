import "package:cv_app/core/assets/assets.gen.dart";
import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/presentation/components/avatar.dart";
import "package:flutter/material.dart";
import "package:utilities/helpers/extensions/build_context.dart";

/// Typography-led hero for the portfolio landing page.
class HeaderView extends StatelessWidget {
  /// [HeaderView] constructor.
  const HeaderView({
    super.key,
    required this.headerModel,
    this.onExploreWork,
    this.onOpenGithub,
  });

  final HeaderModel headerModel;
  final VoidCallback? onExploreWork;
  final VoidCallback? onOpenGithub;

  static const _stack = "Flutter / TypeScript / AWS / PostgreSQL";

  String get _photoPath => headerModel.userDetails.imageUrl ?? Assets.images.avatar.path;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final wide = context.isScreenWidthGreaterThanTablet;

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: context.screenHeight * 0.72),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: tokens.spacing.xl, vertical: tokens.spacing.xxl),
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _Copy(tokens: tokens, title: headerModel.title, onExploreWork: onExploreWork, onOpenGithub: onOpenGithub)),
                  SizedBox(width: tokens.spacing.xxl),
                  CVAvatar.asset(
                    width: (context.screenWidth * 0.22).clamp(220.0, 320.0),
                    assetPath: _photoPath,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Copy(tokens: tokens, title: headerModel.title, onExploreWork: onExploreWork, onOpenGithub: onOpenGithub),
                  SizedBox(height: tokens.spacing.xxl),
                  Align(
                    alignment: Alignment.center,
                    child: CVAvatar.asset(
                      width: 200,
                      assetPath: _photoPath,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _Copy extends StatelessWidget {
  const _Copy({
    required this.tokens,
    required this.title,
    this.onExploreWork,
    this.onOpenGithub,
  });

  final ThemeTokens tokens;
  final String title;
  final VoidCallback? onExploreWork;
  final VoidCallback? onOpenGithub;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 640),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Software Engineer",
            style: tokens.text.bodyMedium?.copyWith(
              letterSpacing: 1.4,
              fontWeight: FontWeight.w600,
              color: tokens.color.onSurfaceWithOpacity(0.55),
            ),
          ),
          SizedBox(height: tokens.spacing.lg),
          Text(
            title,
            style: tokens.text.heroTitle,
          ),
          SizedBox(height: tokens.spacing.lg),
          Text(
            "Building applications from\ninterface to infrastructure.",
            style: tokens.text.headlineSmall?.copyWith(
              fontWeight: FontWeight.w400,
              height: 1.3,
              color: tokens.color.onSurfaceWithOpacity(0.85),
            ),
          ),
          SizedBox(height: tokens.spacing.lg),
          Text(
            HeaderView._stack,
            style: tokens.text.bodyLarge?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.55)),
          ),
          SizedBox(height: tokens.spacing.xxl),
          Wrap(
            spacing: tokens.spacing.md,
            runSpacing: tokens.spacing.sm,
            children: [
              FilledButton(
                onPressed: onExploreWork,
                style: FilledButton.styleFrom(
                  overlayColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text("Explore my work"),
              ),
              OutlinedButton(
                onPressed: onOpenGithub,
                style: OutlinedButton.styleFrom(
                  overlayColor: Colors.transparent,
                  splashFactory: NoSplash.splashFactory,
                ),
                child: const Text("GitHub  ↗"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
