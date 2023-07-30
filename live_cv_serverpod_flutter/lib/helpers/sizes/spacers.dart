import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';

enum SizeTypes { fixed, scaling }

/// Tshirt size options for spacer sizes
enum Sizes {
  zero,
  xxxxs,
  xxxs,
  xxs,
  xs,
  s,
  m,
  l,
  xl,
  xxl,
  xxxl,
  xxxxl;

  /// Returns a [Widget] built from a [SizedBox] with the appropriate height based on the [axis] and [type] supplied.
  Widget spacer({bool vertical = true, SizeTypes type = SizeTypes.fixed}) {
    Axis axis = vertical ? Axis.vertical : Axis.horizontal;
    return _AppSpacer(size: this, axis: axis, type: type);
  }

  /// Returns the pixel value calculated from the [axis] and [type] supplied.
  double points({Axis axis = Axis.vertical, SizeTypes type = SizeTypes.fixed}) {
    final BuildContext context = Managers.navigationService.mainContext;
    switch (type) {
      case SizeTypes.fixed:
        return _getSize();
      case SizeTypes.scaling:
        final Size screenSizePoints = MediaQuery.sizeOf(context);
        final double screenDimension = axis == Axis.vertical ? screenSizePoints.height : screenSizePoints.width;

        final List<ScreenSize> ordered = ScreenSizes.ordered;

        if (screenDimension >= ordered.last.dimension(axis)) {
          return _getSize(screenSize: ordered.last);
        } else if (screenDimension <= ordered.first.dimension(axis)) {
          return _getSize(screenSize: ordered.first);
        } else {
          final indexAfter = ordered.indexWhere((size) => size.dimension(axis) > screenDimension);
          final sizeAfter = ordered[indexAfter];
          final sizeBefore = ordered[indexAfter - 1];
          final dimensionAfter = sizeAfter.dimension(axis);
          final dimensionBefore = sizeBefore.dimension(axis);
          final pointsAfter = _getSize(screenSize: sizeAfter);
          final pointsBefore = _getSize(screenSize: sizeBefore);

          final percentage = (screenDimension - dimensionBefore) / (dimensionAfter - dimensionBefore);
          final points = pointsBefore + (pointsAfter - pointsBefore) * percentage;
          return points;
        }
    }
  }

  /// Gets the pixel size for the spacer based on the screen size (defaults to ScreenSize.medium)
  double _getSize({ScreenSize? screenSize}) {
    final _AppSizesForScreenSize sizes;
    switch (this) {
      case Sizes.zero:
        sizes = _AppSizesForScreenSize(small: 0.0001, medium: 0.0001, large: 0.0001);
        break;
      case Sizes.xxxxs:
        sizes = _AppSizesForScreenSize(small: 1, medium: 1, large: 1);
        break;
      case Sizes.xxxs:
        sizes = _AppSizesForScreenSize(small: 1, medium: 2, large: 3);
        break;
      case Sizes.xxs:
        sizes = _AppSizesForScreenSize(small: 2, medium: 4, large: 6);
        break;
      case Sizes.xs:
        sizes = _AppSizesForScreenSize(small: 4, medium: 8, large: 12);
        break;
      case Sizes.s:
        sizes = _AppSizesForScreenSize(small: 8, medium: 12, large: 16);
        break;
      case Sizes.m:
        sizes = _AppSizesForScreenSize(small: 12, medium: 16, large: 24);
        break;
      case Sizes.l:
        sizes = _AppSizesForScreenSize(small: 16, medium: 24, large: 32);
        break;
      case Sizes.xl:
        sizes = _AppSizesForScreenSize(small: 24, medium: 32, large: 40);
        break;
      case Sizes.xxl:
        sizes = _AppSizesForScreenSize(small: 32, medium: 48, large: 56);
        break;
      case Sizes.xxxl:
        sizes = _AppSizesForScreenSize(small: 48, medium: 64, large: 80);
        break;
      case Sizes.xxxxl:
        sizes = _AppSizesForScreenSize(small: 96, medium: 128, large: 160);
        break;
    }
    switch (screenSize) {
      case ScreenSizes.small:
        return sizes.small;
      case ScreenSizes.medium:
        return sizes.medium;
      case ScreenSizes.large:
        return sizes.large;
      default:
        return sizes.medium;
    }
  }
}

class _AppSpacer extends StatelessWidget {
  final Sizes size;
  final SizeTypes type;
  final Axis axis;
  const _AppSpacer({Key? key, required this.size, required this.axis, required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: axis == Axis.horizontal ? size.points(axis: axis, type: type) : 0,
      height: axis == Axis.vertical ? size.points(axis: axis, type: type) : 0,
    );
  }
}

/// Used to specify the size for each [Sizes] based on the [ScreenSize]
class _AppSizesForScreenSize {
  final double small;
  final double medium;
  final double large;

  _AppSizesForScreenSize({required this.small, required this.medium, required this.large});
}
