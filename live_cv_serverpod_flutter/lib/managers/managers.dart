import 'package:get_it/get_it.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/helpers/wrappers/scroll_index/controller.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/stack.dart';
import 'package:live_cv_serverpod_flutter/config/flavors/flavor_config.dart';
import 'package:live_cv_serverpod_flutter/helpers/logger/logger.dart';
import 'package:live_cv_serverpod_flutter/managers/flavor.dart';
import 'package:live_cv_serverpod_flutter/managers/theme.dart';
import 'package:live_cv_serverpod_flutter/services/navigation.dart';

final Managers = ManagerInjector.instance;

class ManagerInjector {
  static final ManagerInjector instance = ManagerInjector();
  Future<void> setUpManagersAndServices({required FlavorConfig flavorConfig}) async {
    Logger.print("Starting Base Managers", [LoggerFeature.dependencyInjection]);
    GetIt.instance.registerLazySingleton(() => FlavorManager(flavorConfig: flavorConfig));
    GetIt.instance.registerLazySingleton(() => ThemeManager());
    GetIt.instance.registerLazySingleton(() => ScrollIndexManager());
    GetIt.instance.registerLazySingleton(() => AppNavigationService(NavigationStack("navigationStack")));
  }

  // BuildContext get mainContext => navigationService.mainContext;
  FlavorManager get _flavor => GetIt.instance.get<FlavorManager>();
  ScrollIndexManager get scrollIndex => GetIt.instance.get<ScrollIndexManager>();
  AppNavigationService get navigationService => GetIt.instance.get<AppNavigationService>();
  ThemeManager get theme => GetIt.instance.get<ThemeManager>();
  Client get api => _flavor.flavorConfig.client;
  FlavorConfig get flavor => _flavor.flavorConfig;
}
