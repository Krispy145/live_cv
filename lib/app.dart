import "package:cv_app/dependencies/injection.dart";
import "package:firebase_analytics/firebase_analytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:theme/app/view.dart";

/// Main App Class
class MainApp extends StatelessWidget {
  /// Main App Constructor
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedMaterialApp(
      themeStore: Managers.themeStateStore,
      materialAppBuilder: (lightTheme, darkTheme, currentThemeMode) {
        return MaterialApp.router(
          title: "David Kisbey-Green CV",
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentThemeMode,
          routerConfig: Managers.router.config(
            navigatorObservers: () => !kIsWeb
                ? [
                    FirebaseAnalyticsObserver(
                      analytics: FirebaseAnalytics.instance,
                    ),
                  ]
                : [],
          ),
        );
      },
    );
  }
}
