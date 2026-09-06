import "package:cv_app/app.dart";
import "package:cv_app/config/store.dart";
import "package:cv_app/data/models/user_details_model.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/environments/dev/components/app_bar.dart";
import "package:cv_app/environments/dev/env.dart";
import "package:cv_app/utils/loggers.dart";
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

  // Initialize mappers
  UserDetailsModelMapper.ensureInitialized();
  final loggerFeatures = <Enum, bool>{
    CVAppLoggers.github: true,
    CVAppLoggers.cvApp: true,
    CVPackageLoggers.cvPackage: true,
  };
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
        final theme = AppTheme.currentTheme;
        return Localizations(
          locale: const Locale("en", "US"),
          delegates: const [
            DefaultMaterialLocalizations.delegate,
            DefaultWidgetsLocalizations.delegate,
          ],
          child: Theme(
            data: theme,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: Navigator(
                onGenerateRoute: (settings) {
                  return MaterialPageRoute<void>(
                    settings: settings,
                    builder: (context) {
                      return Stack(
                        fit: StackFit.expand,
                        children: [
                          Column(
                            children: [
                              Material(
                                color: theme.colorScheme.surface,
                                child: SizedBox(
                                  height: store.showDevTools ? 64 : 0,
                                  child: DevAppBar(),
                                ),
                              ),
                              const Expanded(child: MainApp()),
                            ],
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Material(
                              type: MaterialType.transparency,
                              child: IconButton(
                                onPressed: () => Managers.config.toggleDevTools(),
                                icon: store.showDevTools
                                    ? Icon(Icons.visibility_off, color: theme.colorScheme.onSurface)
                                    : Icon(Icons.visibility, color: theme.colorScheme.onSurface),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
