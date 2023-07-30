import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_menu.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navbars/desktop.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navbars/mobile.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/service.dart';
import 'package:live_cv_serverpod_flutter/architecture/params.dart';
import 'package:live_cv_serverpod_flutter/architecture/structure.dart';
import 'package:live_cv_serverpod_flutter/config/flavors/flavor_config.dart';
import 'package:live_cv_serverpod_flutter/config/router/routes.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/helpers/logger/logger.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';
import 'package:live_cv_serverpod_flutter/main_entry_model.dart';
import 'package:live_cv_serverpod_flutter/views/home/params.dart';
import 'package:live_cv_serverpod_flutter/views/home/view.dart';
import 'package:provider/provider.dart';

void mainEntry({required FlavorConfig flavorConfig}) async {
  WidgetsFlutterBinding.ensureInitialized();
  await ManagerInjector.instance.setUpManagersAndServices(flavorConfig: flavorConfig);
  AppRoutes.configureRoutes(Managers.navigationService.router);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My CV',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: Managers.theme.themeMode,
      home: Navigator(
        key: Managers.navigationService.mainNavigator.navigationKey,
        onGenerateRoute: (settings) {
          NavigationService navigationService = Managers.navigationService;
          Logger.print("Adding Classic Route => ${navigationService.debugMessage}", [LoggerFeature.navigation]);
          navigationService.navigationStack.addRouteParamToList(routeParams: StructureParams());
          return MaterialPageRoute(
              builder: (_) => MainNavigator(
                    params: StructureParams(),
                  ));
        },
      ),
    );
  }
}

class MainNavigator extends StatelessWidget {
  final StructureParams? params;
  MainNavigator({
    super.key,
    this.params,
  });

  final viewModel = MainEntryModel();
  final String appTitle = "David Kisbey-Green";

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainEntryModel>.value(
      value: viewModel,
      builder: (context, w) => Structure(
        header: ScreenSize.valueForScreen(
          mobile: NavbarMobile.right(
            titleOption: Text(
              appTitle,
              style: AppTheme.currentTheme.textTheme.titleSmall,
            ),
            controller: viewModel.controller,
          ),
          desktop: NavbarDesktop(
            titleOption: Text(
              appTitle,
              style: AppTheme.currentTheme.textTheme.titleSmall,
            ),
            buttonItems: viewModel.navbarItems,
          ),
        ),
        rightNavbarDrawer: NavbarMenuDrawer.right(
          controller: viewModel.controller,
          showMenuCross: false,
          menuBody: NavbarMenuDrawerBody.builder(
            childCount: viewModel.controller.navBarItems.length,
            childBuilder: (context, index) => viewModel.controller.navBarItems[index],
          ),
        ),
        initialBodyParams: HomeParams(),
        body: HomeView(),
      ),
    );
  }
}
