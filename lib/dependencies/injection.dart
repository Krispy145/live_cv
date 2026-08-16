import "package:cv_app/config/store.dart";
import "package:cv_app/core/assets/assets.gen.dart";
import "package:cv_app/navigation/routes.dart";
import "package:cv_app/navigation/wrappers/store.dart";
import "package:cv_app/presentation/landing/store.dart";
import "package:cv_app/utils/loggers.dart";
import "package:get_it/get_it.dart";
import "package:theme/app/store.dart";
import "package:theme/data/repositories/theme_configuration.dart";
import "package:utilities/flavors/flavor_manager.dart";
import "package:utilities/logger/logger.dart";
import "package:utilities/stores/user_location_store.dart";
import "package:utilities/widgets/connection_state/store.dart";

/// Shared package-level service locator used by [Managers].
// ignore: non_constant_identifier_names
final Packages = _PackageInjector.instance;

class _PackageInjector {
  _PackageInjector._();

  static final _PackageInjector instance = _PackageInjector._();
  final GetIt _getIt = GetIt.instance;

  Future<void> init(
    ConfigStore config, {
    required String baseThemePath,
    required String componentThemePath,
  }) async {
    if (!_getIt.isRegistered<AppLoggerInjector>()) {
      _getIt.registerSingleton<AppLoggerInjector>(
        AppLoggerInjector(
          config.loggerFeatures,
          overrideFeatures: config.overrideFeatures,
        ),
      );
    }

    if (!_getIt.isRegistered<ConnectionStateStore>()) {
      _getIt.registerLazySingleton<ConnectionStateStore>(ConnectionStateStore.new);
    }

    if (!_getIt.isRegistered<ThemeStateStore>()) {
      _getIt.registerSingleton<ThemeStateStore>(
        ThemeStateStore(
          initialBaseThemeConfiguration: ThemeConfiguration.assets(rootBundleKey: baseThemePath),
          initialComponentThemesConfiguration: ThemeConfiguration.assets(rootBundleKey: componentThemePath),
        ),
      );
    }
  }

  void add<T extends Object>(T instance) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerSingleton<T>(instance);
    }
  }

  void addLazy<T extends Object>(T Function() factoryFn) {
    if (!_getIt.isRegistered<T>()) {
      _getIt.registerLazySingleton<T>(factoryFn);
    }
  }

  T get<T extends Object>() => _getIt.get<T>();

  ConnectionStateStore get connectionStateStore => get<ConnectionStateStore>();

  ThemeStateStore get themeStateStore => get<ThemeStateStore>();
}

/// [Managers] is a variable that handles all service locator registrations.
// ignore: non_constant_identifier_names
final Managers = _ManagerInjector.instance;

/// [_ManagerInjector] is a class that handles all service locator registrations.
class _ManagerInjector {
  /// [_ManagerInjector] constructor.
  _ManagerInjector._();

  /// [_ManagerInjector] instance setter.
  static final _ManagerInjector instance = _ManagerInjector._();
  final injector = Packages;

  /// [init] is responsible for initializing all service locator registrations.
  Future<void> init({required ConfigStore config}) async {
    await injector.init(
      config,
      baseThemePath: Assets.themes.baseTheme,
      componentThemePath: Assets.themes.componentsTheme,
    );
    AppLogger.print(
      "Initializing ManagerInjector...",
      [CVAppLoggers.dependencyInjection],
    );
    _initCore(config: config);
    _initApp();
    _initExternal();
    AppLogger.print(
      "ManagerInjector initialization complete.",
      [CVAppLoggers.dependencyInjection],
      type: LoggerType.confirmation,
    );
  }

  /// Method responsible for handling all service locator registrations for core classes used in multiple features.
  void _initCore({required ConfigStore config}) {
    AppLogger.print(
      "Initializing core services...",
      [CVAppLoggers.dependencyInjection],
    );
    injector
      ..add(AppRouter())
      ..add<FlavorManager>(
        FlavorManager(flavorConfig: config),
      );

    ///END OF CORE
  }

  /// Method responsible for handling all service locator registrations for the app classes used in multiple features.
  void _initApp() {
    AppLogger.print(
      "Initializing app services...",
      [CVAppLoggers.dependencyInjection],
    );
    injector
      ..addLazy(UserLocationStore.new)
      ..addLazy(AppStore.new)
      ..addLazy(LandingStore.new);

    ///END OF APP
  }

  /// Method responsible for handling all service locator registrations for external services.
  void _initExternal() {
    AppLogger.print(
      "Initializing external services...",
      [CVAppLoggers.dependencyInjection],
    );

    ///END OF EXTERNAL
  }

  /// Getters for all services
  /// [AppRouter] getter
  AppRouter get router => injector.get<AppRouter>();

  /// [FlavorManager] getter
  FlavorManager get _flavor => injector.get<FlavorManager>();

  /// [ConfigStore] getter
  ConfigStore get config => _flavor.flavorConfig as ConfigStore;

  /// [ConnectionStateStore] getter
  ConnectionStateStore get connectionStateStore => injector.connectionStateStore;

  /// [ThemeStateStore] getter
  ThemeStateStore get themeStateStore => injector.themeStateStore;

  /// [UserLocationStore] getter
  UserLocationStore get userLocationStore => injector.get<UserLocationStore>();

  /// [AppStore] getter
  AppStore get appWrapperStore => injector.get<AppStore>();

  /// [LandingStore] getter
  LandingStore get landingStore => injector.get<LandingStore>();
}
