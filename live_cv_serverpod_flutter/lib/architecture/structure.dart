import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/footers/footer.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/header.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/bottom_nav_bar.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_menu.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/params/app_params.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/service.dart';
import 'package:live_cv_serverpod_flutter/helpers/logger/logger.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';

/// Main Scaffold Key for the [Structure] Classic Structure Layout
///
/// Used to control the left and right Drawers for the displaying [YNavbarMobile.left] and [YNavbarMobile.right]
final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

/// Used for the navigation the body layout of the classic structure
// final bodyNavigationStack = YNavigationStack("Body");

// /// BuildContext of the body navigation state
// final bodyContext = bodyNavigationStack.context;

/// [Structure] layout builder that includes a [YHeader] header, a body and an optional [Footer] footer
class Structure extends StatelessWidget {
  /// [YHeader] classic layout
  final Header header;

  /// [BaseRouteParams] Params of the inital navigation route
  final AppParams initialBodyParams;

  /// body of the initial view
  final Widget body;

  /// [Footer] classic layout
  final Footer? footer;

  /// Optional background color of the body
  final Color? backgroundColor;

  /// [leftNavbarDrawer],[rightNavbarDrawer] and [fullNavbarDrawer] menu's for mobile and tablet use cases
  final NavbarMenuDrawer? leftNavbarDrawer;
  final NavbarMenuDrawer? rightNavbarDrawer;
  final BottomNavbar? fullNavbarDrawer;

  /// Classic Structure constructor for building [Structure.desktop] desktop layout
  const Structure({
    super.key,
    required this.header,
    required this.initialBodyParams,
    required this.body,
    this.footer,
    this.backgroundColor,
    this.leftNavbarDrawer,
    this.rightNavbarDrawer,
    this.fullNavbarDrawer,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Managers.navigationService.pop();
        return Future.value(false);
      },
      child: Stack(
        children: [
          Scaffold(
            key: scaffoldKey,
            extendBody: true,
            appBar: header,
            drawer: leftNavbarDrawer,
            endDrawer: rightNavbarDrawer,
            body: Column(
              children: [
                Expanded(
                  child: Navigator(
                    key: Managers.navigationService.bodyNavigator.navigationKey,
                    onGenerateRoute: (settings) {
                      NavigationService navigationService = Managers.navigationService;
                      Logger.print("Adding Classic Route => ${navigationService.debugMessage}", [LoggerFeature.navigation]);
                      navigationService.navigationStack.addRouteParamToList(routeParams: initialBodyParams);
                      return MaterialPageRoute(builder: (_) => body);
                    },
                  ),
                ),
                if (footer != null) footer!,
              ],
            ),
          ),
          if (fullNavbarDrawer != null) fullNavbarDrawer!,
        ],
      ),
    );
  }
}
