// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i4;
import 'package:cv_app/navigation/wrappers/app.wrapper.dart' as _i1;
import 'package:cv_app/presentation/landing/single/view.dart' as _i2;
import 'package:cv_app/presentation/portfolio/single/view.dart' as _i3;
import 'package:cv_package/data/models/portfolio_model.dart' as _i6;
import 'package:flutter/material.dart' as _i5;

/// generated route for
/// [_i1.AppWrapperView]
class AppWrapperRoute extends _i4.PageRouteInfo<AppWrapperRouteArgs> {
  AppWrapperRoute({
    _i5.Key? key,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          AppWrapperRoute.name,
          args: AppWrapperRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'AppWrapperRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AppWrapperRouteArgs>(
          orElse: () => const AppWrapperRouteArgs());
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
  LandingRoute({
    _i5.Key? key,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          LandingRoute.name,
          args: LandingRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'LandingRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<LandingRouteArgs>(orElse: () => const LandingRouteArgs());
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
/// [_i3.PortfolioView]
class PortfolioRoute extends _i4.PageRouteInfo<PortfolioRouteArgs> {
  PortfolioRoute({
    _i5.Key? key,
    String? id,
    _i6.PortfolioModel? portfolioModel,
    List<_i4.PageRouteInfo>? children,
  }) : super(
          PortfolioRoute.name,
          args: PortfolioRouteArgs(
            key: key,
            id: id,
            portfolioModel: portfolioModel,
          ),
          initialChildren: children,
        );

  static const String name = 'PortfolioRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PortfolioRouteArgs>(
          orElse: () => const PortfolioRouteArgs());
      return _i3.PortfolioView(
        key: args.key,
        id: args.id,
        portfolioModel: args.portfolioModel,
      );
    },
  );
}

class PortfolioRouteArgs {
  const PortfolioRouteArgs({
    this.key,
    this.id,
    this.portfolioModel,
  });

  final _i5.Key? key;

  final String? id;

  final _i6.PortfolioModel? portfolioModel;

  @override
  String toString() {
    return 'PortfolioRouteArgs{key: $key, id: $id, portfolioModel: $portfolioModel}';
  }
}
