import "package:cv_app/dependencies/injection.dart";
import "package:cv_package/presentation/landing/store.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:theme/extensions/build_context.dart";
import "package:utilities/helpers/extensions/build_context.dart";
import "package:utilities/helpers/extensions/string.dart";
import "package:utilities/sizes/spacers.dart";

/// [MainAppBar] is a class that defines the main app bar of the app.
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  /// [MainAppBar] constructor.
  const MainAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(96);

  LandingStore get store => Managers.landingStore;

  @override
  Widget build(BuildContext context) {
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
                    IconButton(
                      onPressed: Managers.themeStateStore.toggleThemeMode,
                      icon: Icon(
                        Icons.palette,
                        size: 24,
                        color: context.colorScheme.onSurface,
                      ),
                    ),
                    Sizes.l.spacer(axis: Axis.horizontal),
                    InkWell(
                      onTap: () => store.scrollToIndex(0),
                      child: Text(
                        title,
                        style: context.textTheme.headlineMedium?.copyWith(color: context.colorScheme.onSurface),
                      ),
                    ),
                  ],
                ),
                // Using ResponsiveBreakpoints to switch between a Row and a Dropdown
                Observer(
                  builder: (context) {
                    // Check if the current breakpoint is mobile or tablet
                    if (context.isScreenWidthGreaterThanTablet) {
                      return Row(
                        children: LandingOption.appbarOptions.map(
                          (option) {
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
                          },
                        ).toList(),
                      );
                    } else {
                      return PopupMenuButton<String>(
                        onSelected: (value) {
                          final index = LandingOption.values.indexWhere((option) => option.name == value);
                          if (index != -1) {
                            store.scrollToIndex(index);
                          }
                        },
                        icon: Icon(Icons.menu, color: context.colorScheme.onSurface),
                        itemBuilder: (context) {
                          return LandingOption.appbarOptions.map(
                            (option) {
                              return PopupMenuItem<String>(
                                value: option.name,
                                child: Text(option.name.capitalizeFirst()),
                              );
                            },
                          ).toList();
                        },
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
}
