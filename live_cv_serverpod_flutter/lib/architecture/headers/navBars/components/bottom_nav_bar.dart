import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_controller.dart';
import 'package:live_cv_serverpod_flutter/architecture/headers/navBars/components/nav_bar_menu.dart';
import 'package:live_cv_serverpod_flutter/helpers/durations.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';

/// [BottomNavbar] Creates A Bottom Drawer type Widget that Animates from bottom to top of screen
class BottomNavbar extends StatefulWidget {
  final NavBarController controller;
  const BottomNavbar({
    super.key,
    required this.body,
    this.navBarHeight,
    this.color,
    this.duration,
    this.callback,
    required this.controller,
  });

  @override
  State<BottomNavbar> createState() => _BottomNavbarState();

  /// [NavbarMenuDrawer] body builder of the [BottomNavbar] which takes in the [YNavBarController] to control opening/closing the Navbar
  final NavbarMenuDrawer Function(NavBarController) body;

  /// Height of the Navbar the drawer will animate to when opening
  final double? navBarHeight;

  /// Color of the Navbar
  final Color? color;

  /// Animation Duration of the Navbar when opening/closing
  ///
  /// Defaulted to:
  /// ```dart
  /// YDurations.m.duration
  ///```
  final Duration? duration;

  /// Optional callback for when when opening/closing Navbar
  final Function(bool opened)? callback;
}

class _BottomNavbarState extends State<BottomNavbar> with TickerProviderStateMixin {
  bool opened = false;

  late double navBarHeight;

  double offset = 0.0;

  double scrollOffset = 0.0;
  bool scrollAtEdge = false;

  late Animation<double> animation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: widget.duration ?? Durations.s.duration,
    );

    widget.controller.onOpenChangedHandler = (open) {
      if (open) {
        this.open(false);
      } else {
        close(false);
      }
    };
  }

  double get navbarHeight => ScreenSize.valueForScreen(mobile: 94, tablet: 94, desktop: 64);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (mounted) {
      navBarHeight = screenHeight - (widget.navBarHeight ?? navbarHeight);
      offset = navBarHeight;
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      shape: const AppShape.rectangle(
        width: double.infinity,
        height: double.infinity,
      ),
      alignment: Alignment.bottomCenter,
      child: buildDrawer(),
    );
  }

  /// Builds the drawer animation from bottom to top
  Widget buildDrawer() {
    offset = offset.clamp(0.0, navBarHeight);
    return Transform.translate(
      offset: Offset(0.0, offset),
      child: buildMenu(),
    );
  }

  /// Builds the menu Widget for the Navbar
  Widget buildMenu() {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: navBarHeight,
      ),
      child: widget.body(widget.controller),
    );
  }

  // NAVBAR CONTROLS //
  void open([bool? callback]) {
    if (!opened) {
      double end = 0;
      double? start = offset;
      slide(start, end, callback ?? true);
    }
  }

  void close([bool? callback]) {
    if (opened) {
      double end = navBarHeight;
      double? start = offset;
      slide(start, end, callback ?? true);
    }
  }

  void slide(double? start, double end, bool callback) {
    opened = end == 0.0;

    if (callback) widget.callback?.call(opened);

    CurvedAnimation curve = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    );

    animation = Tween(
      begin: start,
      end: end,
    ).animate(curve)
      ..addListener(() {
        setState(() {
          offset = animation.value;
        });
      });

    animationController.reset();
    animationController.forward();
  }
}
