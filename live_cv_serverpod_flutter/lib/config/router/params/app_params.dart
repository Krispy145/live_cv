import 'package:live_cv_serverpod_flutter/config/router/params/path_params.dart';
import 'package:live_cv_serverpod_flutter/config/router/params/query_params.dart';

abstract class AppParams {
  String path;
  Object? params;
  PathParams? pathParams;
  QueryParams? queryParams;
  AppParams({
    required this.path,
    this.params,
    this.pathParams,
    this.queryParams,
  });

  @override
  String toString() {
    return 'AppParams(path: $path, params: $params, pathParams: $pathParams, queryParams: $queryParams)';
  }

  @override
  bool operator ==(covariant AppParams other) {
    if (identical(this, other)) return true;

    return other.path == path && other.params == params && other.pathParams == pathParams && other.queryParams == queryParams;
  }

  @override
  int get hashCode {
    return path.hashCode ^ params.hashCode ^ pathParams.hashCode ^ queryParams.hashCode;
  }
}
