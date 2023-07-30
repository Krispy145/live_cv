import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/shape_type.dart';

/// A class used to provide widgets with a shape.

/// This object needs to have a [type] to determine what shape to build and the size
/// is determined by the [height] and [width] properties.

/// A border can be provided by giving this object a [border] property.
class AppShape {
  final AppShapeType type;
  final AppBorderRadius? radius;
  final Border? border;
  final double? width;
  final double? height;
  final double? maxHeight;
  final double? maxWidth;

  BoxShape get boxShape {
    switch (type) {
      case AppShapeType.circle:
        return BoxShape.circle;
      default:
        return BoxShape.rectangle;
    }
  }

  BorderRadius? get borderRadius => radius?.borderRadius(height: height);

  const AppShape.pill({
    this.border,
    this.height,
    this.width,
    this.maxHeight,
    this.maxWidth,
  })  : type = AppShapeType.pill,
        radius = AppBorderRadius.pill;

  const AppShape.circle({
    this.border,
    double? size,
  })  : width = size,
        height = size,
        maxHeight = null,
        maxWidth = null,
        type = AppShapeType.circle,
        radius = null;

  const AppShape.rectangle({
    this.border,
    this.width,
    this.height,
    this.maxHeight,
    this.maxWidth,
    this.radius = AppBorderRadius.none,
  }) : type = AppShapeType.rectangle;
}
