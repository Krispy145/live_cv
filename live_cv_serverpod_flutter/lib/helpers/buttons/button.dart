import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/gesture_recognizer.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/scaling.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

import 'button_sizes.dart';
import 'button_types.dart';

/// A clickable widget.

/// The following constructors are used to create the desired button by assigning the
/// [type] property.

/// Use the [Button.textPill] to produce a button with solely text as the child.

/// Use the [Button.icon] to produce a button with solely an icon as the child.

/// Use the [Button.leadingIcon] to produce a button with an icon followed by text as the child.

/// Use the [Button.trailingIcon] to produce a button with text followed by an icon as the child.

/// Pass functions to [onTap], [onHold] and [onDoubleTap] to give this widget the relevant actions as needed.

/// Specify the [color] property to control the color / gradient of this widget accordingly.

/// Use the [shadow] properties to create the desired shadow effect surrounding the button.

/// The [horizontalScaling] field is used to determine how this widget should scale horizontally.
class Button extends StatefulWidget {
  final Color? color;
  final Color? textColor;
  final Color? hoverColor;
  final String? buttonText;
  final Icon Function(double size, Color color)? iconBuilder;
  final ButtonTypes type;
  final ButtonSizes size;
  final ScalingStyle horizontalScaling;
  final Function()? onTap;
  final Function()? onHold;
  final Function()? onDoubleTap;

  /// A [Button] widget that accepts only text as the child element.
  const Button.textPill({
    super.key,
    this.color,
    this.textColor,
    required this.buttonText,
    this.horizontalScaling = const ScalingStyle.fill(),
    this.size = ButtonSizes.m,
    this.onTap,
    this.onDoubleTap,
    this.onHold,
  })  : iconBuilder = null,
        hoverColor = null,
        type = ButtonTypes.textPill;

  const Button.text({
    super.key,
    this.textColor,
    this.hoverColor,
    required this.buttonText,
    this.horizontalScaling = const ScalingStyle.fill(),
    this.size = ButtonSizes.m,
    this.onTap,
    this.onDoubleTap,
    this.onHold,
  })  : iconBuilder = null,
        color = null,
        type = ButtonTypes.text;

  /// A [Button] widget that accepts only an icon as the child element.
  const Button.icon({
    super.key,
    this.color,
    this.hoverColor,
    required this.iconBuilder,
    this.onTap,
    this.onDoubleTap,
    this.onHold,
  })  : textColor = null,
        buttonText = "",
        type = ButtonTypes.icon,
        size = ButtonSizes.m,
        horizontalScaling = const ScalingStyle.fixed(128);

  /// A [Button] widget that accepts both text and icon as the child elements,
  /// combined together in a row displaying the icon on the left.
  const Button.leadingIcon({
    super.key,
    this.color,
    required this.iconBuilder,
    this.textColor,
    this.hoverColor,
    required this.buttonText,
    this.horizontalScaling = const ScalingStyle.fill(),
    this.onTap,
    this.onDoubleTap,
    this.onHold,
  })  : type = ButtonTypes.leadingIcon,
        size = ButtonSizes.m;

  /// A [Button] widget that accepts both text and icon as the child elements,
  /// combined together in a row displaying the text on the left.
  const Button.trailingIcon({
    super.key,
    this.color,
    required this.iconBuilder,
    this.textColor,
    this.hoverColor,
    required this.buttonText,
    this.horizontalScaling = const ScalingStyle.fill(),
    this.onTap,
    this.onDoubleTap,
    this.onHold,
  })  : type = ButtonTypes.trailingIcon,
        size = ButtonSizes.m;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  late TextStyle? _hoverTextStyle = AppTheme.currentTheme.textTheme.labelSmall?.copyWith(color: widget.type == ButtonTypes.textPill ? Colors.white : widget.textColor);
  TextStyle? get hoverTextStyle => _hoverTextStyle;
  void _setHoverTextStyle(bool isHovering, Color? color) => setState(() {
        isHovering
            ? _hoverTextStyle = AppTheme.currentTheme.textTheme.labelSmall?.copyWith(color: color)
            : _hoverTextStyle = AppTheme.currentTheme.textTheme.labelSmall?.copyWith(color: widget.type == ButtonTypes.textPill ? Colors.white : widget.textColor);
      });

  /// Returns a [Text] widget with the given text string.
  Widget textWidget(BuildContext context) => Text(
        widget.buttonText ?? "",
        style: hoverTextStyle,
      );

  Widget wrappedTextWidget(BuildContext context) => shouldFill
      ? Center(child: textWidget(context))
      : Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [textWidget(context)],
        );

  EdgeInsets padding(BuildContext context) => AppEdgeInsets.symmetric(horizontal: Sizes.l);

  double? get width => widget.horizontalScaling.dimension;

  AppShape get shapePill => AppShape.pill(width: width, height: widget.size.height);

  AppShape get shapeRectangle => AppShape.rectangle(width: width, height: widget.size.height);

  bool get shouldFill => widget.horizontalScaling.style == ScalingStyles.fill;

  bool get shouldShrink => widget.horizontalScaling.style == ScalingStyles.shrink;

  @override
  Widget build(BuildContext context) {
    return GestureRecognizer(
      onTap: widget.onTap,
      onTapHold: widget.onHold,
      onHover: (isHovering) => _setHoverTextStyle(isHovering, Colors.green[700]),
      onDoubleTap: widget.onDoubleTap,
      child: _buildButtonContainer(),
    );
  }

  Widget _buildButtonContainer() {
    switch (widget.type) {
      case ButtonTypes.text:
        return AppContainer(
          shape: shapeRectangle,
          child: wrappedTextWidget(context),
        );
      case ButtonTypes.textPill:
        return AppContainer(
          shape: shapePill,
          color: widget.color,
          padding: padding(context),
          child: wrappedTextWidget(context),
        );
      case ButtonTypes.icon:
        return AppContainer(
          shape: shapePill,
          color: widget.color,
          padding: padding(context),
          child: widget.iconBuilder!(widget.size.iconSize, Colors.blueGrey[700]!),
        );
      case ButtonTypes.leadingIcon:
      case ButtonTypes.trailingIcon:
        return AppContainer(
          shape: shapePill,
          color: widget.color,
          padding: padding(context),
          child: Row(
            mainAxisSize: widget.horizontalScaling.style == ScalingStyles.shrink ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (widget.type == ButtonTypes.leadingIcon) widget.iconBuilder!(widget.size.iconSize, Colors.blueGrey[700]!),
              shouldFill ? Expanded(child: wrappedTextWidget(context)) : Flexible(child: wrappedTextWidget(context)),
              if (widget.type == ButtonTypes.trailingIcon) widget.iconBuilder!(widget.size.iconSize, Colors.blueGrey[700]!),
            ],
          ),
        );
    }
  }
}
