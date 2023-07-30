import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

class AppEdgeInsets extends EdgeInsets {
  const AppEdgeInsets.zero() : super.all(0);

  AppEdgeInsets.only({
    Sizes? left,
    Sizes? right,
    Sizes? top,
    Sizes? bottom,
    SizeTypes type = SizeTypes.fixed,
  }) : super.only(
          left: left?.points(axis: Axis.horizontal, type: type) ?? 0,
          right: right?.points(axis: Axis.horizontal, type: type) ?? 0,
          top: top?.points(axis: Axis.vertical, type: type) ?? 0,
          bottom: bottom?.points(axis: Axis.vertical, type: type) ?? 0,
        );

  AppEdgeInsets.symmetric({
    Sizes? horizontal,
    Sizes? vertical,
    SizeTypes type = SizeTypes.fixed,
  }) : super.symmetric(
          horizontal: horizontal?.points(axis: Axis.horizontal, type: type) ?? 0,
          vertical: vertical?.points(axis: Axis.vertical, type: type) ?? 0,
        );

  AppEdgeInsets.all(
    Sizes size, {
    SizeTypes type = SizeTypes.fixed,
  }) : super.all(size.points(axis: Axis.vertical, type: type));
}
