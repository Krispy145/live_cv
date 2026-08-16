import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/navigation/components/animated_theme_toggle.dart";
import "package:cv_app/navigation/wrappers/store.dart";
import "package:cv_package/core/theme/theme_tokens.dart";
import "package:cv_package/data/models/header_model.dart";
import "package:cv_package/presentation/landing/store.dart";
import "package:cv_package/presentation/resume/resume_preview_dialog.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:theme/extensions/build_context.dart";
import "package:utilities/helpers/extensions/build_context.dart";
import "package:utilities/helpers/extensions/string.dart";
import "package:utilities/sizes/spacers.dart";

/// [MainAppBar] is a class that defines the main app bar of the app.
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// [MainAppBar] constructor.
  const MainAppBar({super.key, required this.title});

  @override
  Size get preferredSize => const Size.fromHeight(96);

  LandingStore get store => Managers.landingStore;
  HeaderModel get headerModel => Managers.appWrapperStore.headerModel;
  AppStore get appStore => Managers.appWrapperStore;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final _headlineTextStyle = context.isScreenWidthGreaterThanTablet
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
                      onTap: () => store.scrollToIndex(0),
                      child: Text(title, style: _headlineTextStyle),
                    ),
                  ],
                ),
                // Using ResponsiveBreakpoints to switch between a Row and a Dropdown
                Observer(
                  builder: (context) {
                    // Check if the current breakpoint is mobile or tablet
                    if (context.isScreenWidthGreaterThanTablet) {
                      return Row(
                        children: [
                          ...LandingOption.appbarOptions.map((option) {
                            final index = LandingOption.values.indexOf(option);
                            return Padding(
                              padding: const EdgeInsets.all(8),
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: store.isCurrentIndex(index) ? context.colorScheme.secondary : context.colorScheme.primary,
                                  foregroundColor: store.isCurrentIndex(index) ? context.colorScheme.onSecondary : context.colorScheme.onPrimary,
                                ),
                                onPressed: () => store.scrollToIndex(index),
                                child: Text(option.name.capitalizeFirst()),
                              ),
                            );
                          }),
                          Sizes.xs.spacer(axis: Axis.horizontal),
                          _buildDownloadButton(context, tokens),
                        ],
                      );
                    } else {
                      return Row(
                        children: [
                          PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == "download") {
                                ResumePreviewDialog.show(context, header: headerModel, cachedPdfBytes: appStore.cachedPdfBytes);
                              } else {
                                final index = LandingOption.values.indexWhere((option) => option.name == value);
                                if (index != -1) {
                                  store.scrollToIndex(index);
                                }
                              }
                            },
                            icon: Icon(Icons.menu, color: context.colorScheme.onSurface),
                            itemBuilder: (context) {
                              return [
                                ...LandingOption.appbarOptions.map((option) {
                                  return PopupMenuItem<String>(value: option.name, child: Text(option.name.capitalizeFirst()));
                                }),
                                const PopupMenuItem<String>(value: "download", child: Text("Download Resume")),
                              ];
                            },
                          ),
                        ],
                      );
                    }
                  },
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
