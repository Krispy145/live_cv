import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Top Level [GestureRecognizer] GestureRecognizer to classify between pointers (mouse) and taps (finger taps)
class GestureRecognizer extends StatelessWidget {
  final void Function(bool isHovering)? onHover;
  final void Function()? onTap;
  final void Function()? onTapHold;
  final void Function()? onDoubleTap;
  final Widget child;
  final void Function(DragUpdateDetails)? onVerticalDragUpdate;

  const GestureRecognizer({
    super.key,
    this.onHover,
    required this.onTap,
    this.onTapHold,
    this.onDoubleTap,
    this.onVerticalDragUpdate,
    required this.child,
  });

  //TODO: Setup better getter for touch vs pointer devices
  bool get isTouchDevice => defaultTargetPlatform == TargetPlatform.android || defaultTargetPlatform == TargetPlatform.iOS;
  // bool get isTouchDevice => YScreenSize.isMobile;

  @override
  Widget build(BuildContext context) {
    return isTouchDevice
        ? _YTapper(
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onTapHold: onTapHold,
            onVerticalDragUpdate: onVerticalDragUpdate,
            child: child,
          )
        : _YHoverPointer(
            onHover: onHover,
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onTapHold: onTapHold,
            child: child,
          );
  }
}

class _YTapper extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onTapHold;
  final void Function()? onDoubleTap;
  final void Function(DragUpdateDetails)? onVerticalDragUpdate;
  final Widget? child;

  const _YTapper({
    required this.onTap,
    required this.child,
    required this.onTapHold,
    required this.onDoubleTap,
    required this.onVerticalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onTapHold,
      onVerticalDragUpdate: onVerticalDragUpdate,
      child: child,
    );
  }
}

class _YHoverPointer extends StatelessWidget {
  final void Function(bool isHovering)? onHover;
  final void Function()? onTap;
  final void Function()? onTapHold;
  final void Function()? onDoubleTap;
  final Widget child;
  const _YHoverPointer({
    required this.onHover,
    required this.onTap,
    required this.onTapHold,
    required this.onDoubleTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: onHover,
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      onLongPress: onTapHold,
      hoverColor: Colors.transparent,
      child: child,
    );
  }
}
