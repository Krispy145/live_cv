import 'package:live_cv_serverpod_flutter/architecture/navigation/params/app_params.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';

class DialogParams extends AppParams {
  final String dialogParams;
  DialogParams(this.dialogParams)
      : super(
          path: dialogParams,
          navigator: Managers.navigationService.mainNavigator,
        );
}
