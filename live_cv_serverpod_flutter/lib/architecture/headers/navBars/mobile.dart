import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_controller.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/header.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/gesture_recognizer.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

class NavbarMobile extends Header {
  final Color? navBarColor;

  /// Left Navbar Widget display (e.g Tappable Icon to go to home view)
  final Widget? leftOptionOpen;
  final Widget? leftOptionClose;

  /// Title Navbar Widget display (e.g Tappable Icon to go to home view)
  final Widget? titleOption;

  /// Right Navbar Widget display (e.g Tappable Icon to go to home view)
  final Widget? rightOptionOpen;
  final Widget? rightOptionClose;

  /// Optional Function to action when [YNavbarMobile.left] or [YNavbarMobile.right] is tapped
  final Function()? onTap;

  /// Optional title Function to action when titleOption is tapped
  final Function()? onTitleTap;

  /// Height of the Desktop Navbar
  ///
  /// Defaulted to _defaultHeight
  final double navBarHeight;

  /// Type of the Desktop Navbar type
  final NavBarType navBarType;

  /// Type of the Desktop Navbar Menu type
  final MenuType menuType;

  /// Conditional for if the option defaults should change if open/closed
  final bool shouldToggleMenu;

  /// [NavBarController] controller for animation control and action setters
  final NavBarController controller;

  static const double _defaultHeight = 68;

  /// Left Navbar constructor
  NavbarMobile.left({
    Key? key,
    this.leftOptionOpen,
    this.leftOptionClose,
    this.titleOption,
    this.navBarHeight = _defaultHeight,
    this.navBarColor,
    this.onTap,
    this.shouldToggleMenu = true,
    this.onTitleTap,
    this.navBarType = NavBarType.left,
    this.menuType = MenuType.left,
    required this.controller,
  })  : preferredSize = Size.fromHeight(navBarHeight),
        rightOptionOpen = null,
        rightOptionClose = null,
        super(key: key);

  /// Right Navbar constructor
  NavbarMobile.right({
    Key? key,
    this.titleOption,
    this.navBarHeight = _defaultHeight,
    this.navBarColor,
    this.shouldToggleMenu = true,
    this.rightOptionOpen,
    this.rightOptionClose,
    this.onTap,
    this.onTitleTap,
    this.navBarType = NavBarType.right,
    this.menuType = MenuType.right,
    required this.controller,
  })  : preferredSize = Size.fromHeight(navBarHeight),
        leftOptionOpen = null,
        leftOptionClose = null,
        super(key: key);

  /// Full Navbar constructor
  NavbarMobile.full({
    Key? key,
    this.titleOption,
    this.navBarHeight = _defaultHeight,
    this.navBarColor,
    this.onTitleTap,
    this.shouldToggleMenu = true,
    this.navBarType = NavBarType.full,
    this.menuType = MenuType.full,
    required this.controller,
  })  : preferredSize = Size.fromHeight(navBarHeight),
        leftOptionOpen = null,
        rightOptionOpen = null,
        leftOptionClose = null,
        rightOptionClose = null,
        onTap = null,
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: SafeArea(
        bottom: false,
        child: AppContainer(
          shape: AppShape.rectangle(height: navBarHeight),
          padding: AppEdgeInsets.only(top: Sizes.xs),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Padding(
                  padding: AppEdgeInsets.only(top: Sizes.l, bottom: Sizes.m),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [_buildLeading(context), _buildTitle(context), _buildTrailing(context)],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Function to action open/closed if should toggle the option
  Function() _toggleOpenClosed() {
    if (controller.isOpen(menuType) && shouldToggleMenu) {
      return () => controller.close(menuType);
    } else {
      return () => controller.open(menuType);
    }
  }

  /// Function to action option type if should toggle the option
  Widget _toggleOption(BuildContext context, Widget? optionOpen, Widget? optionClosed) {
    if (controller.isOpen(menuType) && shouldToggleMenu) {
      return optionOpen ?? Icon(Icons.close, color: Colors.blueGrey[700]);
    } else {
      return optionClosed ?? Icon(Icons.list, color: Colors.blueGrey[700]);
    }
  }

  /// Builds the left option
  Widget _buildLeading(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Sizes.xl.spacer(vertical: false, type: SizeTypes.fixed),
          navBarType == NavBarType.left
              ? GestureRecognizer(
                  onTap: onTap ?? _toggleOpenClosed(),
                  child: _toggleOption(context, leftOptionOpen, leftOptionClose),
                )
              : const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// Builds the title option or defaults to app logo
  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleOption ??
            GestureRecognizer(
              onTap: () {
                if (onTitleTap != null) onTitleTap!();
              },
              child: titleOption ?? Icon(Icons.circle, color: Colors.blueGrey[700]),
            ),
      ],
    );
  }

  /// Builds the right option
  Widget _buildTrailing(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          navBarType == NavBarType.right
              ? GestureRecognizer(
                  onTap: onTap ?? _toggleOpenClosed(),
                  child: rightOptionOpen ?? _toggleOption(context, rightOptionOpen, rightOptionClose),
                )
              : const SizedBox(width: 40),
          Sizes.xl.spacer(vertical: false, type: SizeTypes.fixed),
        ],
      ),
    );
  }
}
