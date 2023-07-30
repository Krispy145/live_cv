import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_controller.dart';
import 'package:live_cv_serverpod_flutter/helpers/buttons/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/scaling.dart';
import 'package:provider/provider.dart';

/// [NavbarItem] menu item for [YHeader]'s
class NavbarItem extends StatelessWidget {
  ///Inex of item in the navbar list
  final String path;

  /// [MenuType] type (to control which type of Navbar to close)
  final MenuType type;

  /// Function to action when tapping item
  final Function() onTap;

  /// Title of item
  final String title;

  /// Optional [TextStyle] of title
  ///
  /// Defaults to:
  /// ```dart
  /// TextStyle.mBold
  /// ```
  final TextStyle? textStyle;

  /// Optional text color of title
  ///
  /// Defaults to:
  /// ```dart
  /// Color.black
  /// ```
  final Color? textColor;

  /// Optional text color of title
  ///
  /// Defaults to:
  /// ```dart
  /// Color.redFaded
  /// ```
  final Color? hoverColor;

  /// Optional text color of title
  ///
  /// Defaults to:
  /// ```dart
  /// Color.red
  /// ```
  final Color? selectedColor;

  const NavbarItem({
    Key? key,
    required this.title,
    this.textStyle,
    this.textColor,
    required this.type,
    required this.onTap,
    required this.path,
    this.hoverColor,
    this.selectedColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarController>(
      builder: (context, controller, _) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Button.text(
                horizontalScaling: const ScalingStyle.shrink(),
                buttonText: title,
                hoverColor: hoverColor,
                onTap: () {
                  onTap();
                  controller.setSelectedItem(path);
                }),
          ],
        );
      },
    );
  }
}
