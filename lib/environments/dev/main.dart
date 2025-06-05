import "package:cv_app/app.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/environments/dev/components/app_bar.dart";
import "package:cv_app/environments/dev/env.dart";
import "package:cv_package/config/store.dart";
import "package:firebase_core/firebase_core.dart";
import "package:firebase_crashlytics/firebase_crashlytics.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_web_plugins/url_strategy.dart";
import "package:theme/app/app.dart";

import "../../firebase/firebase_options_dev.dart";

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  final loggerFeatures = <Enum, bool>{};
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
    );
  }

  //Initialize firebase project
  await Firebase.initializeApp(
    name: !kIsWeb ? DevEnv.name : null,
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final config = ConfigStore(
    DevEnv.name,
    // ignore: avoid_redundant_argument_values
    showDevTools: kDebugMode && kIsWeb,
    loggerFeatures: loggerFeatures,
    domain: kDebugMode ? "http://localhost:8080" : "https://lets-yak-app-dev.web.app",
  );
  await Managers.init(config: config);

  if (!kIsWeb) {
    // Pass all uncaught "fatal" errors from the framework to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  runApp(
    kDebugMode ? DevApp() : const MainApp(),
  );
}

class DevApp extends StatelessWidget {
  DevApp({
    super.key,
  });

  final store = Managers.config;

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (context) {
        return MaterialApp(
          theme: AppTheme.currentTheme,
          debugShowCheckedModeBanner: false,
          home: Stack(
            children: [
              Scaffold(
                appBar: DevAppBar(),
                body: const MainApp(),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  onPressed: () => Managers.config.toggleDevTools(),
                  icon: store.showDevTools
                      ? Icon(
                          Icons.visibility_off,
                          color: AppTheme.currentTheme.colorScheme.onSurface,
                        )
                      : Icon(
                          Icons.visibility,
                          color: AppTheme.currentTheme.colorScheme.onSurface,
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
