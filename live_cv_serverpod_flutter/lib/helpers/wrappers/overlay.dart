import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/durations.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';

class OverlayWrapper extends StatefulWidget {
  final Widget child;
  final bool expand;
  // final BoxDecoration? decoration;
  final AppShape? shape;
  final Color? color;
  const OverlayWrapper({
    Key? key,
    this.expand = false,
    required this.child,
    // this.decoration,
    this.shape,
    this.color,
  }) : super(key: key);

  @override
  OverlayWrapperState createState() => OverlayWrapperState();
}

class OverlayWrapperState extends State<OverlayWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final Animation<double> sizeAnimation;
  late final Animation<double> opacityAnimation;
  OverlayEntry? floatingDropdown;
  GlobalKey actionKey = GlobalKey();
  double height = 0, width = 0, xPosition = 0, yPosition = 0;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    super.initState();
    prepareAnimations();
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

  void _expandedCollapseCheck() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.expand) {
        animationController.forward();
        findDropdownData();
        floatingDropdown ??= _createFloatingDropdown();
        final overlayState = Overlay.maybeOf(context);
        if (!floatingDropdown!.mounted) {
          overlayState?.insert(floatingDropdown!);
        }
      } else {
        floatingDropdown?.remove();
        animationController.reverse();
      }
    });
  }

  @override
  void didUpdateWidget(OverlayWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    _expandedCollapseCheck();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
    floatingDropdown?.remove();
  }

  void findDropdownData() {
    RenderBox renderBox = actionKey.currentContext!.findRenderObject() as RenderBox;
    height = renderBox.size.height;
    width = renderBox.size.width;
    Offset offset = renderBox.localToGlobal(Offset.zero);
    xPosition = offset.dx;
    yPosition = offset.dy;
  }

  OverlayEntry _createFloatingDropdown() {
    return OverlayEntry(
      builder: (context) {
        return Positioned(
          left: xPosition,
          width: width,
          top: yPosition,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            child: AppContainer(
              shape: widget.shape,
              color: widget.color,
              clipBehaviour: Clip.none,
              // decoration: widget.decoration,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: FadeTransition(
        key: actionKey,
        opacity: opacityAnimation,
        child: SizeTransition(
          axisAlignment: 1.0,
          sizeFactor: sizeAnimation,
        ),
      ),
    );
  }
}
