import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';

/// A widget used to provide styling to [AppContainer].

/// /// Specify the [shape] and [color] properties to control the shape and color / gradient
/// of this widget accordingly. A [backgroundBlendMode] can be used for further control
/// over the blend mode of the color or gradient.

/// Use the [border] and [shadow] properties to create the desired border effect as necessary.
class AppBoxDecoration extends BoxDecoration {
  AppBoxDecoration({
    AppShape? shape,
    Color? color,
    AppBorder? border,
    BlendMode? backgroundBlendMode,
  }) : super(
          borderRadius: shape?.borderRadius,
          border: border?.border,
          color: color,
          shape: shape?.boxShape ?? BoxShape.rectangle,
          backgroundBlendMode: backgroundBlendMode,
        );
}
