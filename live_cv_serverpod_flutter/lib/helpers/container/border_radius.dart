import 'package:flutter/material.dart';

/// An enum used to specify the style of the corners of an object.
enum AppBorderRadius {
  none,
  rectangleRounded,
  rectangleXRounded,
  rectangleXXRounded,
  rectangleXXXRounded,
  rectangleXXXXRounded,
  rectangleXXXXXRounded,
  rectangleXXXXXXRounded,
  pill;

  double radius(double? height) {
    switch (this) {
      case AppBorderRadius.none:
        return 0;
      case AppBorderRadius.rectangleRounded:
        return 6;
      case AppBorderRadius.rectangleXRounded:
        return 8;
      case AppBorderRadius.rectangleXXRounded:
        return 10;
      case AppBorderRadius.rectangleXXXRounded:
        return 12;
      case AppBorderRadius.rectangleXXXXRounded:
        return 14;
      case AppBorderRadius.rectangleXXXXXRounded:
        return 16;
      case AppBorderRadius.rectangleXXXXXXRounded:
        return 20;
      case AppBorderRadius.pill:
        return height != null ? height / 2 : 20000;
    }
  }

  BorderRadius borderRadius({double? height}) => BorderRadius.circular(radius(height));
}
