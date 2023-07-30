import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/params/app_params.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/stack.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/logger/logger.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

final GlobalKey<ScaffoldState> mainScaffoldKey = GlobalKey<ScaffoldState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

class NavigationService<ParamsType extends AppParams> {
  String debugMessage = "navigationService";

  NavigationService(this.navigationStack);

  ///MAIN NAVIGATOR BUILDCONTEXT AND DECLARATION
  BuildContext get mainContext => mainNavigator.context;
  final mainNavigator = AppNavigator("Main");

  ///BODY NAVIGATOR BUILDCONTEXT AND DECLARATION
  final bodyNavigator = AppNavigator("Body");
  BuildContext get bodyContext => bodyNavigator.context;

  final NavigationStack<ParamsType> navigationStack;

  FluroRouter router = FluroRouter();

  Future<void> showDialogBase({
    required Widget view,
    required ParamsType params,
    double? width,
    double? height,
    Color barrierColor = Colors.transparent,
    bool useSafeArea = false,
    bool canDismissFromBarrier = false,
    bool useRootNavigator = false,
    RouteSettings? routeSettings,
    Function()? beforeShowing,
  }) {
    navigationStack.addRouteParamToList(routeParams: params);
    if (beforeShowing != null) beforeShowing();
    return showDialog(
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      routeSettings: routeSettings,
      barrierDismissible: canDismissFromBarrier,
      useRootNavigator: useRootNavigator,
      context: params.navigator.context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: AppBorderRadius.rectangleXXXXXXRounded.borderRadius()),
        content: AppContainer(
          margin: AppEdgeInsets.all(Sizes.l),
          shape: AppShape.rectangle(
              width: ScreenSize.valueForScreen(mobile: screenWidth / 0.05, tablet: screenWidth / 0.1, desktop: screenWidth / 3),
              height: ScreenSize.valueForScreen(mobile: screenHeight / 0.2, tablet: screenHeight / 0.25, desktop: screenHeight / 1.5)),
          color: Colors.white,
          child: SingleChildScrollView(child: view),
        ),
      ),
    );
  }

  bool pop<T>({T? result, Function(ParamsType goingTo)? beforePopping}) {
    final ParamsType currentRoute = navigationStack.latestRoute!;
    if (Navigator.canPop(currentRoute.navigator.context)) {
      navigationStack.removeRouteParams(routeParams: currentRoute);
      final ParamsType? goingTo = navigationStack.latestRoute;
      if (beforePopping != null && goingTo != null) beforePopping(goingTo);
      router.pop(currentRoute.navigator.context, result);
      Logger.print("${currentRoute.navigator.debugName} Pop -> Going to: ${goingTo?.path}", [LoggerFeature.navigation]);
      return true;
    } else {
      Logger.print("Pop -> Did not pop", [LoggerFeature.navigation]);
      return false;
    }
  }

  void popStack<T>({T? result, Function(ParamsType)? beforePoppingStack}) {
    final routesList = navigationStack.routesList;
    if (routesList.isNotEmpty) {
      final ParamsType goingTo = routesList.first;
      Logger.print("Going to: ${goingTo.runtimeType}", [LoggerFeature.navigation]);
      if (beforePoppingStack != null) beforePoppingStack(goingTo);
      popUntil(goingTo);
    }
  }

  void popUntil(ParamsType params, {Function(ParamsType)? beforePopping}) {
    final routesList = navigationStack.routesList;
    if (routesList.contains(params)) {
      if (beforePopping != null) beforePopping(params);
    }
    while (routesList.last != params) {
      bool result = pop();
      if (!result) break;
    }
  }

  Future<void> pushTo(
    ParamsType params, {
    bool replace = false,
    Function(ParamsType)? beforePushing,
    TransitionType? transition = TransitionType.inFromRight,
    Duration? transitionDuration,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)? transitionBuilder,
  }) async {
    Logger.print("About to Push => $debugMessage", [LoggerFeature.navigation]);
    if (beforePushing != null) beforePushing(params);

    if (replace) {
      Logger.print("Push -> Replace route: true", [LoggerFeature.navigation]);
      navigationStack.replaceTopRouteParams(routeParams: params);
    } else {
      Logger.print("Push -> Replace route: false\nNavigator - ${params.navigator}", [LoggerFeature.navigation]);
      navigationStack.addRouteParamToList(routeParams: params);
    }
    var result = await router.navigateTo(
      params.navigator.navigationKey.currentState!.context,
      params.path,
      replace: replace,
      maintainState: params.maintainState,
      transition: transitionBuilder != null ? TransitionType.custom : transition,
      transitionBuilder: transitionBuilder,
      transitionDuration: transitionDuration,
      routeSettings: RouteSettings(arguments: params),
    );
    return result;
  }

  Future<void> pushStack({
    required List<ParamsType> routes,
    Function(ParamsType)? beforePushingStack,
    TransitionType? transition = TransitionType.inFromRight,
    Duration? transitionDuration,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)? transitionBuilder,
  }) async {
    if (routes.isNotEmpty) {
      if (beforePushingStack != null) beforePushingStack(routes.last);
      for (var route in routes) {
        await pushTo(
          route,
          transition: transition,
          transitionBuilder: transitionBuilder,
          transitionDuration: transitionDuration,
        );
      }
    }
  }

  Future<void> pushClearStack(
    ParamsType params, {
    Function(ParamsType)? beforePushing,
    TransitionType? transition = TransitionType.inFromRight,
  }) async {
    if (beforePushing != null) beforePushing(params);
    navigationStack.removeAllRouteParamsFromNavigator(params.navigator);
    navigationStack.addRouteParamToList(routeParams: params);
    var result = await router.navigateTo(
      params.navigator.context,
      params.path,
      transition: transition,
      clearStack: true,
      maintainState: params.maintainState,
      routeSettings: RouteSettings(arguments: params),
    );
    return result;
  }
}
