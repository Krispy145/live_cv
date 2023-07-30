import 'package:live_cv_serverpod_flutter/architecture/navigation/params/app_params.dart';
import 'package:live_cv_serverpod_flutter/config/router/routes.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';

class StructureParams extends AppParams {
  StructureParams()
      : super(
          path: AppRoutes.structure.route.path,
          navigator: Managers.navigationService.mainNavigator,
        );
}
