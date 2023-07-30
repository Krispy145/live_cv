import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/route.dart';
import 'package:live_cv_serverpod_flutter/architecture/params.dart';
import 'package:live_cv_serverpod_flutter/helpers/logger/logger.dart';
import 'package:live_cv_serverpod_flutter/main_entry.dart';
import 'package:live_cv_serverpod_flutter/views/home/params.dart';
import 'package:live_cv_serverpod_flutter/views/home/view.dart';

// END OF IMPORTS

enum AppRoutes {
  structure,
  home,
  cv,
  portfolio,
// END OF ROUTES ENUM
  ;

  NewRoute get route {
    switch (this) {
      case AppRoutes.structure:
        return NewRoute(
          path: "/",
          handler: (context) => MainNavigator(params: context?.settings?.arguments as StructureParams?),
        );
      case AppRoutes.home:
        return NewRoute(
          path: "/home",
          handler: (context) => HomeView(params: context?.settings?.arguments as HomeParams),
        );
      case AppRoutes.cv:
        return NewRoute(
          path: "/cv",
          handler: (context) => HomeView(params: context?.settings?.arguments as HomeParams),
        );
      case AppRoutes.portfolio:
        return NewRoute(
          path: "/portfolio",
          handler: (context) => HomeView(params: context?.settings?.arguments as HomeParams),
        );

// END OF ROUTES SWITCH
    }
  }

  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      Logger.print("Route not found!", [LoggerFeature.navigation]);
      return;
    });

    for (AppRoutes route in AppRoutes.values) {
      router.define(route.route.path, handler: Handler(handlerFunc: (context, parameters) => route.route.handler(context)));
    }
  }
}
