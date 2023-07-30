// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fluro/fluro.dart';

import 'package:live_cv_serverpod_flutter/architecture/navigation/stack.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/params/path_params.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/params/query_params.dart';

abstract class AppParams {
  String path;
  bool maintainState;
  TransitionType? transition;
  Duration? transitionDuration;
  AppNavigator navigator;
  PathParams? pathParams;
  QueryParams? queryParams;
  AppParams({
    required this.path,
    this.maintainState = false,
    this.transition,
    this.transitionDuration,
    required this.navigator,
    this.pathParams,
    this.queryParams,
  });

  @override
  String toString() {
    return 'AppParams(path: $path, maintainState: $maintainState, transition: $transition, transitionDuration: $transitionDuration, navigator: ${navigator.debugName}, pathParams: $pathParams, queryParams: $queryParams)';
  }

  @override
  bool operator ==(covariant AppParams other) {
    if (identical(this, other)) return true;

    return other.path == path &&
        other.maintainState == maintainState &&
        other.transition == transition &&
        other.transitionDuration == transitionDuration &&
        other.navigator == navigator &&
        other.pathParams == pathParams &&
        other.queryParams == queryParams;
  }

  @override
  int get hashCode {
    return path.hashCode ^ maintainState.hashCode ^ transition.hashCode ^ transitionDuration.hashCode ^ navigator.hashCode ^ pathParams.hashCode ^ queryParams.hashCode;
  }
}
