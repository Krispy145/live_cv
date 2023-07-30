import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_controller.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/header.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/extensions/list.dart';
import 'package:live_cv_serverpod_flutter/helpers/gesture_recognizer.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

/// Desktop Navbar for [Header] use in classic structure
class NavbarDesktop extends Header {
  /// Optional Navbar color setter
  ///
  final Color? navBarColor;

  /// Left Navbar Widget display (e.g Tappable Icon to go to home view)
  final Widget? leftOption;

  /// Title Navbar Widget display (e.g Tappable Icon to go to home view)
  final Widget? titleOption;

  /// Optional title Function to action when leftOption tapped
  final Function()? onLeftOptionTap;

  /// Height of the Desktop Navbar
  ///
  /// Defaulted to 64
  final double navBarHeight;

  /// Type of the Desktop Navbar type
  ///
  /// Defaulted to:
  /// ```dart
  /// YNavBarType.full
  /// ```
  final NavBarType type;

  final List<Widget> buttonItems;

  NavbarDesktop({
    Key? key,
    this.leftOption,
    this.titleOption,
    this.navBarHeight = 68,
    this.navBarColor,
    this.onLeftOptionTap,
    required this.buttonItems,
  })  : preferredSize = Size.fromHeight(navBarHeight),
        type = NavBarType.full,
        super(key: key);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: AppContainer(
        padding: AppEdgeInsets.symmetric(vertical: Sizes.xs),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [_buildLeading(context), _buildTitle(), _buildTrailing(context, buttonItems)],
        ),
      ),
    );
  }

  /// Builds the left option or defaults to app logo
  Widget _buildLeading(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Sizes.xl.spacer(vertical: false, type: SizeTypes.fixed),
          leftOption ??
              GestureRecognizer(
                onTap: () {
                  if (onLeftOptionTap != null) onLeftOptionTap!();
                  // BlocProvider.of<YNavBarBloc>(context).add(UpdateSelectedIndexEvent(index: 0));
                },
                child: Icon(Icons.circle, color: Colors.blueGrey[700]),
              ),
        ],
      ),
    );
  }

  /// Builds the Title option or colors space
  Widget _buildTitle() {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        titleOption ?? const SizedBox(width: 40),
      ],
    );
  }

  /// Builds the right options
  Widget _buildTrailing(BuildContext context, List<Widget> buttonItems) {
    return Expanded(
      child: Padding(
        padding: AppEdgeInsets.only(right: Sizes.xl),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: buttonItems.map<Widget>((e) => Padding(padding: AppEdgeInsets.only(right: Sizes.m), child: e)).toList()
            ..insertBetween(
              Sizes.xs.spacer(
                vertical: false,
                type: SizeTypes.fixed,
              ),
            ),
        ),
      ),
    );
  }
}
