import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/shape_type.dart';

/// A widget that surrounds its child to provide custom styling.

/// Specify the [shape] and [color] properties to control the shape and color / gradient
/// of this widget accordingly. A [backgroundBlendMode] can be used for further control
/// over the blend mode of the color or gradient.

/// If external space around this widget is needed, then [margin] can be given ,
/// whereas [padding] can be given to ensure there is space between the edge of
/// this widget and its child. Further control of the child position can be
/// achieved by using the [alignment] property.

/// Use the [border] and [shadow] properties to create the desired border effect as necessary.

/// A blur overlay effect can be implemented by giving this widget a [blur].
class AppContainer extends StatelessWidget {
  final AppShape? shape;
  final Color? color;
  final Widget? child;
  final AppBorder? border;
  final AppBackgroundBlur? blur;
  final Clip clipBehaviour;
  final AlignmentGeometry? alignment;
  final BlendMode? backgroundBlendMode;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final bool dottedBorder;
  const AppContainer({
    super.key,
    this.shape,
    this.color,
    this.border,
    this.dottedBorder = false,
    this.blur,
    this.alignment,
    this.margin,
    this.padding,
    this.clipBehaviour = Clip.hardEdge,
    this.backgroundBlendMode,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final radius = shape?.radius?.radius(shape?.height);
    return dottedBorder
        ? DottedBorder(
            color: border?.color ?? Colors.transparent,
            radius: radius != null ? Radius.circular(radius) : const Radius.circular(0),
            borderType: shape?.type == AppShapeType.circle ? BorderType.Circle : BorderType.RRect,
            strokeWidth: border?.size.width ?? 1,
            child: buildContainer(),
          )
        : buildContainer();
  }

  Container buildContainer() {
    return Container(
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: AppBoxDecoration(
        shape: shape,
        color: color,
        border: !dottedBorder ? border : null,
        backgroundBlendMode: backgroundBlendMode,
      ),
      width: shape?.width,
      height: shape?.height,
      constraints: BoxConstraints(maxHeight: shape?.maxHeight ?? double.infinity, maxWidth: shape?.maxWidth ?? double.infinity),
      child: Container(
        clipBehavior: clipBehaviour,
        decoration: AppBoxDecoration(shape: shape),
        child: blur != null ? AppBlurredContainer(blurDetails: blur!, borderRadius: shape?.radius, child: child) : child,
      ),
    );
  }
}
