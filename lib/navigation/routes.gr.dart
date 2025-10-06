// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:cv_app/features/github/presentation/projects_view.dart' as _i3;
import 'package:cv_app/navigation/wrappers/app.wrapper.dart' as _i1;
import 'package:cv_app/presentation/landing/single/view.dart' as _i2;
import 'package:flutter/material.dart' as _i5;

/// generated route for
/// [_i1.AppWrapperView]
class AppWrapperRoute extends _i4.PageRouteInfo<AppWrapperRouteArgs> {
  AppWrapperRoute({_i5.Key? key, List<_i4.PageRouteInfo>? children})
    : super(
        AppWrapperRoute.name,
        args: AppWrapperRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'AppWrapperRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppWrapperRouteArgs>(
        orElse: () => const AppWrapperRouteArgs(),
      );
      return _i1.AppWrapperView(key: args.key);
    },
  );
}

class AppWrapperRouteArgs {
  const AppWrapperRouteArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'AppWrapperRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.LandingView]
class LandingRoute extends _i4.PageRouteInfo<LandingRouteArgs> {
  LandingRoute({_i5.Key? key, List<_i4.PageRouteInfo>? children})
    : super(
        LandingRoute.name,
        args: LandingRouteArgs(key: key),
        initialChildren: children,
      );

  static const String name = 'LandingRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LandingRouteArgs>(
        orElse: () => const LandingRouteArgs(),
      );
      return _i2.LandingView(key: args.key);
    },
  );
}

class LandingRouteArgs {
  const LandingRouteArgs({this.key});

  final _i5.Key? key;

  @override
  String toString() {
    return 'LandingRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i3.ProjectsView]
class ProjectsRoute extends _i4.PageRouteInfo<void> {
  const ProjectsRoute({List<_i4.PageRouteInfo>? children})
    : super(ProjectsRoute.name, initialChildren: children);

  static const String name = 'ProjectsRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.ProjectsView();
    },
  );
}
