import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

class DescriptionContainer extends StatelessWidget {
  final AppEdgeInsets? padding;
  final Description description;
  final CrossAxisAlignment? crossAxisAlignment;
  final double? width;
  final Color? textColor;

  const DescriptionContainer({
    Key? key,
    required this.description,
    this.padding,
    this.width,
    this.textColor,
    this.crossAxisAlignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? AppEdgeInsets.all(Sizes.xs),
      width: width,
      child: Column(
        crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
        children: [
          if (description.header != null) Sizes.m.spacer(),
          if (description.header != null)
            Text(
              description.header!,
              style: AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: textColor),
            ),
          if (description.header != null && description.subheader != null) Sizes.s.spacer(),
          if (description.subheader != null)
            Text(
              description.subheader!,
              style: AppTheme.currentTheme.textTheme.titleSmall?.copyWith(color: textColor),
            ),
          if (description.subheader != null && description.paragraph != null) Sizes.s.spacer(),
          ParagraphText(
            text: description.paragraph!,
            textColor: textColor,
          )
        ],
      ),
    );
  }
}

class ParagraphText extends StatelessWidget {
  final List<String?> text;
  final Color? textColor;
  const ParagraphText({super.key, required this.text, this.textColor});

  @override
  Widget build(BuildContext context) {
    TextStyle? textStyle = AppTheme.currentTheme.textTheme.bodyMedium?.copyWith(color: textColor);
    return text.length == 1
        ? Text(
            "${text[0] ?? "Null paragraph text string"}\n\n",
            style: textStyle,
          )
        : RichText(
            text: TextSpan(
              children: text.map((str) {
                return TextSpan(text: '$str\n\n', style: textStyle);
              }).toList(),
            ),
          );
  }
}
