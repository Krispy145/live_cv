import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_controller.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/gesture_recognizer.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

/// [NavbarMenuDrawer] menu for all Drawers (leftNavbar/rightNavbar/fullNavbar)
class NavbarMenuDrawer extends StatelessWidget {
  /// [NavBarController] controller to control openig/closing animations
  final NavBarController controller;

  /// [MenuType] type of menu used for identifying animation (left/right/full)
  final MenuType type;

  /// Left Menu Widget display (e.g Tappable Icon to open drawer)
  final Widget? leftMenuOption;

  /// Title Menu Widget display (e.g Tappable Icon to open drawer)
  final Widget? titleOption;

  /// Right Menu Widget display (e.g Tappable Icon to open drawer)
  final Widget? rightMenuOption;

  /// Function to action when tapping close on drawer type
  final Function()? onCloseTap;

  /// [NavbarMenuDrawerBody] layout builder with [MenuType] and [NavBarController] for helpers
  final NavbarMenuDrawerBody menuBody;

  /// Displays cross icon for closing menu drawer
  ///
  /// Defaulted to true
  final bool showMenuCross;

  /// Left Menu constructor
  const NavbarMenuDrawer.left({
    super.key,
    this.rightMenuOption,
    this.onCloseTap,
    required this.menuBody,
    required this.controller,
    this.showMenuCross = true,
  })  : leftMenuOption = null,
        titleOption = null,
        type = MenuType.left,
        _isFull = false;

  /// Right Menu constructor
  const NavbarMenuDrawer.right({
    super.key,
    this.rightMenuOption,
    this.onCloseTap,
    required this.menuBody,
    required this.controller,
    this.showMenuCross = true,
  })  : leftMenuOption = null,
        titleOption = null,
        type = MenuType.right,
        _isFull = false;

  /// Full Menu constructor
  const NavbarMenuDrawer.full({
    super.key,
    this.rightMenuOption,
    this.onCloseTap,
    required this.menuBody,
    required this.controller,
    this.showMenuCross = true,
  })  : leftMenuOption = null,
        titleOption = null,
        type = MenuType.full,
        _isFull = true;

  final bool _isFull;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: screenWidth - (_isFull ? 0 : Sizes.xxxxl.points(axis: Axis.horizontal, type: SizeTypes.fixed)),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: AppEdgeInsets.only(top: Sizes.m),
                child: AppContainer(
                  shape: const AppShape.rectangle(height: 24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [_buildLeading(), _buildTitle(), _buildTrailing(context)],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: AppEdgeInsets.only(
                    top: Sizes.l,
                    left: Sizes.xl,
                    right: Sizes.xl,
                    bottom: Sizes.xl,
                  ),
                  child: menuBody,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the left option or colors space
  Widget _buildLeading() {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Sizes.m.spacer(vertical: false, type: SizeTypes.fixed),
          leftMenuOption ?? const SizedBox(width: 40),
        ],
      ),
    );
  }

  /// Builds the title option or colors space
  Widget _buildTitle() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        titleOption ?? const SizedBox(width: 40),
      ],
    );
  }

  /// Builds the right option or colors space
  Widget _buildTrailing(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          showMenuCross
              ? GestureRecognizer(
                  onTap: onCloseTap ?? () => controller.close(type),
                  child: rightMenuOption ?? Icon(Icons.close, color: Colors.blueGrey[700]),
                )
              : const SizedBox(width: 40),
          Sizes.m.spacer(vertical: false, type: SizeTypes.fixed),
        ],
      ),
    );
  }
}

///[NavbarMenuDrawerBody] body layout builder for the Navbar menu:
class NavbarMenuDrawerBody extends StatelessWidget {
  /// Optional Body Title
  final String? title;

  /// Optional alignment override for centering
  final TextAlign titleAlignment;

  /// Child count for builder constructor
  final int? childCount;

  /// Child builder function of types [YNavbarItem] for builder constructor
  final Widget Function(BuildContext, int)? childBuilder;

  /// Optional Separator for builder constructor
  ///
  /// Defaults to:
  /// ```dart
  /// AppSizes.xs.spacer( type: AppSizeTypes.fixed),
  /// ```
  final Widget Function(BuildContext, int)? childSeparator;

  /// List customized Widgets
  final List<Widget>? children;

  /// Optional bottom spacer for end of list spacing
  final Sizes? bottomSpacer;

  final bool shrinkWrap;

  /// Main menu body constructor
  const NavbarMenuDrawerBody({
    Key? key,
    this.title,
    this.titleAlignment = TextAlign.left,
    this.shrinkWrap = false,
    required this.children,
    this.bottomSpacer,
  })  : childCount = null,
        childBuilder = null,
        childSeparator = null,
        super(
          key: key,
        );

  /// menu body builder constructor
  const NavbarMenuDrawerBody.builder({
    Key? key,
    this.title,
    this.titleAlignment = TextAlign.left,
    this.childSeparator,
    required this.childCount,
    required this.childBuilder,
    this.bottomSpacer,
  })  : children = null,
        shrinkWrap = true,
        super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        if (title != null)
          Text(
            title!,
            textAlign: titleAlignment,
          ),
        if (title != null) Row(children: [Sizes.l.spacer(type: SizeTypes.fixed)]),
        if (childCount != null && childBuilder != null)
          Expanded(
            child: ListView.separated(
              shrinkWrap: shrinkWrap,
              padding: EdgeInsets.zero,
              physics: const BouncingScrollPhysics(),
              itemCount: childCount!,
              separatorBuilder: childSeparator ?? (context, index) => Sizes.xs.spacer(type: SizeTypes.fixed),
              itemBuilder: (context, index) => childBuilder!(context, index),
            ),
          ),
        if (children != null)
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children!,
              ),
            ),
          ),
        if (bottomSpacer != null) bottomSpacer!.spacer(type: SizeTypes.fixed),
      ],
    );
  }
}
