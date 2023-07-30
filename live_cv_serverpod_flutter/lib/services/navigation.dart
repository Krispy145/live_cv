// END OF IMPORTS

import 'package:live_cv_serverpod_flutter/architecture/navigation/params/app_params.dart';
import 'package:live_cv_serverpod_flutter/architecture/navigation/service.dart';
import 'package:live_cv_serverpod_flutter/views/cv/params.dart';
import 'package:live_cv_serverpod_flutter/views/portfolio/params.dart';
import 'package:live_cv_serverpod_flutter/views/home/params.dart';

class AppNavigationService<ParamsType extends AppParams> extends NavigationService {
  AppNavigationService(super.navigationStack);

  void goBackToHome() => popUntil(HomeParams());

  void goToCV() => pushTo(CVParams());

  void goToPortfolio() => pushTo(PortfolioParams());
  // END OF SERVICE METHODS
}
