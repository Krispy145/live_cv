import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';

class ResponsiveLayout extends StatelessWidget {
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;
  final List<Widget> children;
  final bool isScrollable;
  final AppEdgeInsets? padding;
  const ResponsiveLayout({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.children = const <Widget>[],
    this.padding,
  })  : isScrollable = false,
        super(key: key);
  const ResponsiveLayout.scrollable({
    Key? key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
    this.children = const <Widget>[],
    this.padding,
  })  : isScrollable = true,
        super(key: key);
  Axis get direction => ScreenSize.isDesktop ? Axis.horizontal : Axis.vertical;

  VerticalDirection get verticalDirection => direction == Axis.horizontal ? VerticalDirection.down : VerticalDirection.up;

  @override
  Widget build(BuildContext context) {
    return isScrollable
        ? SingleChildScrollView(
            scrollDirection: direction,
            child: buildContent(),
          )
        : buildContent();
  }

  Widget buildContent() {
    return Padding(
      padding: padding ?? const AppEdgeInsets.zero(),
      child: Flex(
        direction: direction,
        verticalDirection: verticalDirection,
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: direction == Axis.horizontal ? children : children.reversed.toList(),
      ),
    );
  }
}
