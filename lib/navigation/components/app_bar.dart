import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/navigation/components/animated_theme_toggle.dart";
import "package:cv_app/navigation/routes.gr.dart";
import "package:cv_app/navigation/wrappers/store.dart";
import "package:cv_app/presentation/resume/resume_preview_dialog.dart";
import "package:flutter/material.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:theme/extensions/build_context.dart";
import "package:utilities/helpers/extensions/build_context.dart";
import "package:utilities/sizes/spacers.dart";

/// Top-level portfolio destinations.
enum PortfolioNav {
  /// Selected work / landing.
  work,

  /// Engineering stack.
  engineering,

  /// About / CV.
  about,
}

/// [MainAppBar] is a class that defines the main app bar of the app.
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// [MainAppBar] constructor.
  const MainAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(96);

  HeaderModel get headerModel => Managers.appWrapperStore.headerModel;
  AppStore get appStore => Managers.appWrapperStore;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final headlineTextStyle = context.isScreenWidthGreaterThanTablet
        ? context.textTheme.headlineMedium?.copyWith(color: context.colorScheme.onSurface)
        : context.textTheme.headlineSmall?.copyWith(color: context.colorScheme.onSurface);
    return ColoredBox(
      color: context.theme.appBarTheme.backgroundColor ?? context.colorScheme.surface,
      child: PreferredSize(
        preferredSize: preferredSize,
        child: SizedBox(
          height: preferredSize.height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedThemeToggle(color: context.colorScheme.onSurface),
                    Sizes.l.spacer(axis: Axis.horizontal),
                    InkWell(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () => Managers.router.navigate(const AppWrapperRoute(children: [LandingRoute()])),
                      child: Text(title, style: headlineTextStyle),
                    ),
                  ],
                ),
                if (context.isScreenWidthGreaterThanTablet)
                  ListenableBuilder(
                    listenable: Managers.router,
                    builder: (context, _) => Row(
                      children: [
                        ...PortfolioNav.values.map((nav) => _NavButton(nav: nav, tokens: tokens)),
                        Sizes.xs.spacer(axis: Axis.horizontal),
                        _buildDownloadButton(context, tokens),
                      ],
                    ),
                  )
                else
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == "download") {
                        ResumePreviewDialog.show(context, header: headerModel, cachedPdfBytes: appStore.cachedPdfBytes);
                      } else {
                        _go(context, PortfolioNav.values.byName(value));
                      }
                    },
                    icon: Icon(Icons.menu, color: context.colorScheme.onSurface),
                    itemBuilder: (context) => [
                      ...PortfolioNav.values.map((nav) => PopupMenuItem(value: nav.name, child: Text(_label(nav)))),
                      const PopupMenuItem(value: "download", child: Text("Download Resume")),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadButton(BuildContext context, ThemeTokens tokens) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: tokens.color.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(tokens.card.borderRadius),
        border: Border.all(color: tokens.color.primary.withValues(alpha: 0.3), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => ResumePreviewDialog.show(context, header: headerModel, cachedPdfBytes: appStore.cachedPdfBytes),
          borderRadius: BorderRadius.circular(tokens.card.borderRadius),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: tokens.spacing.lg, vertical: tokens.spacing.sm),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                FaIcon(FontAwesomeIcons.download, color: tokens.color.primary, size: 16),
                SizedBox(width: tokens.spacing.sm),
                FaIcon(FontAwesomeIcons.filePdf, color: tokens.color.primary, size: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.nav, required this.tokens});

  final PortfolioNav nav;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final active = _isActive(context, nav);
    return Padding(
      padding: const EdgeInsets.all(8),
      child: TextButton(
        onPressed: () => _go(context, nav),
        style: TextButton.styleFrom(
          foregroundColor: active ? tokens.color.primary : tokens.color.onSurface,
          overlayColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Text(
          _label(nav),
          style: TextStyle(fontWeight: active ? FontWeight.w700 : FontWeight.w500),
        ),
      ),
    );
  }
}

String _label(PortfolioNav nav) => switch (nav) {
      PortfolioNav.work => "Work",
      PortfolioNav.engineering => "Engineering",
      PortfolioNav.about => "About",
    };

bool _isActive(BuildContext context, PortfolioNav nav) {
  final path = Managers.router.currentPath;
  return switch (nav) {
    PortfolioNav.work => path.isEmpty || path == "/" || path.startsWith("/work") || path.startsWith("/projects"),
    PortfolioNav.engineering => path.startsWith("/engineering"),
    PortfolioNav.about => path.startsWith("/about"),
  };
}

void _go(BuildContext context, PortfolioNav nav) {
  final route = switch (nav) {
    PortfolioNav.work => const LandingRoute(),
    PortfolioNav.engineering => const EngineeringRoute(),
    PortfolioNav.about => const AboutRoute(),
  };
  Managers.router.navigate(AppWrapperRoute(children: [route]));
}
