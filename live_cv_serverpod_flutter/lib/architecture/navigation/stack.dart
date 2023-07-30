import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/params/app_params.dart';
import 'package:live_cv_serverpod_flutter/helpers/logger/logger.dart';

class AppNavigator {
  final String debugName;
  final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  AppNavigator(this.debugName);
  BuildContext get context {
    if (navigationKey.currentContext == null) {
      throw Exception('YNavigationStack($debugName): context is null. Navigatation key is not used by any widget.');
    }
    return navigationKey.currentContext!;
  }

  @override
  String toString() => "debugName: $debugName, navigationKey: $navigationKey";
}

class NavigationStack<ParamsType extends AppParams> {
  final String debugName;
  final List<ParamsType> routesList = [];

  NavigationStack(this.debugName);

  ParamsType? get latestRoute => routesList.isNotEmpty ? routesList.last : null;

  void addRouteParamToList({required ParamsType routeParams}) {
    Logger.print("$debugName$hashCode: BEFORE ADD => $routesList", [LoggerFeature.navigation]);
    routesList.add(routeParams);
    SystemNavigator.routeInformationUpdated(location: routeParams.path);
    Logger.print("$debugName$hashCode: Added route => $routesList", [LoggerFeature.navigation]);
  }

  void addAllRouteParamsToList({required List<ParamsType> routeParamsList}) {
    routesList.addAll(routeParamsList);
    SystemNavigator.routeInformationUpdated(location: routeParamsList.last.path);

    Logger.print("Added all routes => $routesList", [LoggerFeature.navigation]);
  }

  void removeRouteParams({required ParamsType routeParams}) {
    if (routesList.isNotEmpty) {
      routesList.remove(routeParams);
      SystemNavigator.routeInformationUpdated(location: routesList.last.path);
      Logger.print("$debugName$hashCode: Removed route => $routesList", [LoggerFeature.navigation]);
    } else {
      Logger.print("$debugName$hashCode: Removed route => Route not found to remove", [LoggerFeature.navigation]);
    }
  }

  void replaceWithSingleRouteParams({required ParamsType routeParams}) {
    routesList.removeWhere((element) => element.navigator == routeParams.navigator);
    routesList.add(routeParams);
    SystemNavigator.routeInformationUpdated(location: routeParams.path);
    Logger.print("$debugName$hashCode: Routes replaced with single => $routesList", [LoggerFeature.navigation]);
  }

  void replaceTopRouteParams({required ParamsType routeParams}) {
    if (routesList.isNotEmpty) {
      routesList.removeLast();
      SystemNavigator.routeInformationUpdated(location: routesList.last.path);

      Logger.print("$debugName$hashCode: Top route replaced => $routesList", [LoggerFeature.navigation]);
    } else {
      Logger.print("$debugName$hashCode: Top route replaced (added as empty) => $routesList", [LoggerFeature.navigation]);
    }
    routesList.add(routeParams);
    SystemNavigator.routeInformationUpdated(location: routeParams.path);
  }

  void removeAllRouteParamsFromNavigator(AppNavigator navigator) {
    Logger.print("$debugName$hashCode Navigator Route Length -> ${routesList.length}", [LoggerFeature.navigation]);
    routesList.removeWhere((element) => element.navigator == navigator);
    SystemNavigator.routeInformationUpdated(location: routesList.last.path);

    Logger.print("All routes from $navigator Navigator removed => $routesList", [LoggerFeature.navigation]);
  }

  void popTopRouteParams() {
    routesList.removeLast();
    SystemNavigator.routeInformationUpdated(location: routesList.last.path);

    Logger.print("Top route popped", [LoggerFeature.navigation]);
  }

  int navigatorRouteLength(String debugName) {
    int result = 0;
    for (var value in routesList) {
      if (value.navigator.debugName == debugName) {
        result++;
      }
    }
    Logger.print("$debugName$hashCode Navigator Route Length -> $result", [LoggerFeature.navigation]);
    return result;
  }
}
