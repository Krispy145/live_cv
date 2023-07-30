import 'package:live_cv_serverpod_flutter/architecture/navigation/params/app_params.dart';
import 'package:live_cv_serverpod_flutter/config/router/routes.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';

class CVParams extends AppParams {
  CVParams()
      : super(
          path: AppRoutes.cv.route.path,
          navigator: Managers.navigationService.bodyNavigator,
        );
}
