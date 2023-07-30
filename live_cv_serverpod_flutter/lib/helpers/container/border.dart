import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/border_size.dart';

/// A class used to specify the border of an object.

/// Use the [YBorder.none()] constructor if an element requires
/// this object, but no border is needed for your use case.

/// The color of the border is taken from the [color] property and
/// the width / thickness of the border is determined using the
/// [size] property.
class AppBorder {
  final Color color;
  final AppBorderSize size;
  final double alignment;

  AppBorder({
    required this.color,
    required this.size,
    this.alignment = BorderSide.strokeAlignCenter,
  });

  Border? get border => size == AppBorderSize.none
      ? null
      : Border.all(
          width: size.width,
          color: color,
          strokeAlign: alignment,
        );

  AppBorder.none()
      : size = AppBorderSize.none,
        color = Colors.transparent,
        alignment = BorderSide.strokeAlignCenter;
}
