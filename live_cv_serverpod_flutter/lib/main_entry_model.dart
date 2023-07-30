import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_controller.dart';
import 'package:live_cv_serverpod_flutter/helpers/buttons/button.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';
import 'package:live_cv_serverpod_flutter/services/navigation.dart';

class MainEntryModel extends ChangeNotifier {
  final AppNavigationService navigationService = Managers.navigationService;
  final scrollIndexController = Managers.scrollIndex;
  NavBarController get controller => NavBarController(
        buttonItems: navbarItems,
      );

  List<Button> get navbarItems => [
        Button.text(
          buttonText: "Intro",
          onTap: () {
            controller.close(MenuType.right);
            scrollIndexController.setIndex(0);
            // navigationService.goBackToHome();
          },
        ),
        Button.text(
          buttonText: "Portfolio",
          onTap: () {
            controller.close(MenuType.right);
            // navigationService.goToCV();
            scrollIndexController.setIndex(1);
          },
        ),
        Button.text(
          buttonText: "About",
          onTap: () {
            controller.close(MenuType.right);
            // navigationService.goToPortfolio();
            scrollIndexController.setIndex(2);
          },
        ),
        Button.text(
          buttonText: "CV",
          onTap: () {
            controller.close(MenuType.right);
            // navigationService.goToPortfolio();
            scrollIndexController.setIndex(3);
          },
        ),
        Button.text(
          buttonText: "Contact",
          onTap: () {
            controller.close(MenuType.right);
            // navigationService.goToPortfolio();
            scrollIndexController.setIndex(4);
          },
        ),
      ];
}
