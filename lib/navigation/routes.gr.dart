// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i7;
import 'package:cv_app/navigation/wrappers/app.wrapper.dart' as _i2;
import 'package:cv_app/presentation/about/about_view.dart' as _i1;
import 'package:cv_app/presentation/engineering/engineering_view.dart' as _i4;
import 'package:cv_app/presentation/github/projects_view.dart' as _i6;
import 'package:cv_app/presentation/landing/single/view.dart' as _i5;
import 'package:cv_app/presentation/work/case_study_view.dart' as _i3;
import 'package:flutter/material.dart' as _i8;

/// generated route for
/// [_i1.AboutView]
class AboutRoute extends _i7.PageRouteInfo<void> {
  const AboutRoute({List<_i7.PageRouteInfo>? children})
      : super(AboutRoute.name, initialChildren: children);

  static const String name = 'AboutRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i1.AboutView();
    },
  );
}

/// generated route for
/// [_i2.AppWrapperView]
class AppWrapperRoute extends _i7.PageRouteInfo<void> {
  const AppWrapperRoute({List<_i7.PageRouteInfo>? children})
      : super(AppWrapperRoute.name, initialChildren: children);

  static const String name = 'AppWrapperRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i2.AppWrapperView();
    },
  );
}

/// generated route for
/// [_i3.CaseStudyView]
class CaseStudyRoute extends _i7.PageRouteInfo<CaseStudyRouteArgs> {
  CaseStudyRoute({
    required String slug,
    _i8.Key? key,
    List<_i7.PageRouteInfo>? children,
  }) : super(
          CaseStudyRoute.name,
          args: CaseStudyRouteArgs(slug: slug, key: key),
          rawPathParams: {'slug': slug},
          initialChildren: children,
        );

  static const String name = 'CaseStudyRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<CaseStudyRouteArgs>(
        orElse: () => CaseStudyRouteArgs(slug: pathParams.getString('slug')),
      );
      return _i3.CaseStudyView(slug: args.slug, key: args.key);
    },
  );
}

class CaseStudyRouteArgs {
  const CaseStudyRouteArgs({required this.slug, this.key});

  final String slug;

  final _i8.Key? key;

  @override
  String toString() {
    return 'CaseStudyRouteArgs{slug: $slug, key: $key}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CaseStudyRouteArgs) return false;
    return slug == other.slug && key == other.key;
  }

  @override
  int get hashCode => slug.hashCode ^ key.hashCode;
}

/// generated route for
/// [_i4.EngineeringView]
class EngineeringRoute extends _i7.PageRouteInfo<void> {
  const EngineeringRoute({List<_i7.PageRouteInfo>? children})
      : super(EngineeringRoute.name, initialChildren: children);

  static const String name = 'EngineeringRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i4.EngineeringView();
    },
  );
}

/// generated route for
/// [_i5.LandingView]
class LandingRoute extends _i7.PageRouteInfo<void> {
  const LandingRoute({List<_i7.PageRouteInfo>? children})
      : super(LandingRoute.name, initialChildren: children);

  static const String name = 'LandingRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i5.LandingView();
    },
  );
}

/// generated route for
/// [_i6.ProjectsView]
class ProjectsRoute extends _i7.PageRouteInfo<void> {
  const ProjectsRoute({List<_i7.PageRouteInfo>? children})
      : super(ProjectsRoute.name, initialChildren: children);

  static const String name = 'ProjectsRoute';

  static _i7.PageInfo page = _i7.PageInfo(
    name,
    builder: (data) {
      return const _i6.ProjectsView();
    },
  );
}
