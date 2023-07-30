import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';

/// A class used to provide blur details to a container.
class AppBackgroundBlur {
  double blur, sigma;
  Color color;

  AppBackgroundBlur({
    required this.blur,
    required this.color,
    required this.sigma,
  });
}

/// A widget that surrounds its child with a blurred background.

/// Specify the [height] and [width] properties to determine the widgets size.

/// Use [borderRadius] to have control over the style of the widgets corners.

/// Blur type can be specified using the [blurDetails] property.

class AppBlurredContainer extends StatelessWidget {
  final Widget? child;
  final double? height;
  final double? width;
  final AppBorderRadius? borderRadius;

  final AppBackgroundBlur blurDetails;

  const AppBlurredContainer({
    super.key,
    this.height,
    this.width,
    AppBorderRadius? borderRadius,
    required this.blurDetails,
    this.child,
  }) : borderRadius = borderRadius ?? AppBorderRadius.none;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius?.borderRadius(height: height),
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: blurDetails.blur,
              sigmaY: blurDetails.blur,
            ),
          ),
          Container(
            height: height,
            width: width,
            color: blurDetails.color,
            child: child,
          ),
        ],
      ),
    );
  }
}
