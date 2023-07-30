import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/durations.dart';

class ExpandableWrapper extends StatefulWidget {
  final Widget child;
  final bool expand;
  final bool reverseAnimationOnChildChange;
  final AppShape? shape;
  final Color? color;

  // Expands the widget from top to bottom (default behavior).
  const ExpandableWrapper.fromTop({
    Key? key,
    this.expand = false,
    this.reverseAnimationOnChildChange = true,
    required this.child,
    this.shape,
    this.color,
  }) : super(key: key);

  // Expands the widget from bottom to top.
  const ExpandableWrapper.fromBottom({
    Key? key,
    this.expand = false,
    this.reverseAnimationOnChildChange = true,
    required this.child,
    this.shape,
    this.color,
  }) : super(key: key);

  // Expands the widget from left to right.
  const ExpandableWrapper.fromLeft({
    Key? key,
    this.expand = false,
    this.reverseAnimationOnChildChange = true,
    required this.child,
    this.shape,
    this.color,
  }) : super(key: key);

  // Expands the widget from right to left.
  const ExpandableWrapper.fromRight({
    Key? key,
    this.expand = false,
    this.reverseAnimationOnChildChange = true,
    required this.child,
    this.shape,
    this.color,
  }) : super(key: key);

  @override
  ExpandableWrapperState createState() => ExpandableWrapperState();
}

class ExpandableWrapperState extends State<ExpandableWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> sizeAnimation;
  late final Animation<double> opacityAnimation;

  @override
  void initState() {
    super.initState();
    prepareAnimations();
    _runExpandCheck();
  }

  void prepareAnimations() {
    animationController = AnimationController(
      vsync: this,
      duration: Durations.xs.duration,
    );
    sizeAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.fastOutSlowIn,
    );
    opacityAnimation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
  }

  void _runExpandCheck() {
    if (widget.expand) {
      animationController.forward();
    } else {
      if (widget.reverseAnimationOnChildChange) animationController.reverse();
    }
  }

  @override
  void didUpdateWidget(ExpandableWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _runExpandCheck();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.expand,
      child: AppContainer(
        shape: widget.shape,
        color: widget.color,
        clipBehaviour: Clip.none,
        child: SizeTransition(
          sizeFactor: sizeAnimation,
          axis: _getExpansionAxis(),
          child: FadeTransition(
            opacity: opacityAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  Axis _getExpansionAxis() {
    if (widget.runtimeType == ExpandableWrapper.fromLeft.runtimeType || widget.runtimeType == ExpandableWrapper.fromRight.runtimeType) {
      return Axis.horizontal;
    } else {
      return Axis.vertical;
    }
  }
}
