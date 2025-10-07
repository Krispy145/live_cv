import "package:cv_package/core/theme/theme_tokens.dart";
import "package:flutter/material.dart";
import "package:utilities/helpers/extensions/build_context.dart";

class SectionBuilder extends StatelessWidget {
  final Widget body;
  final String? title;
  final String? subtitle;
  final double? height;
  final bool isLastSection;

  const SectionBuilder({
    super.key,
    required this.body,
    this.title,
    this.subtitle,
    this.height,
    this.isLastSection = false,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: height ?? context.screenHeight * 0.8,
      ),
      decoration: BoxDecoration(
        color: tokens.color.surface,
        border: Border(
          top: BorderSide(
            color: tokens.color.outline.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: tokens.spacing.xl,
          right: tokens.spacing.xl,
          top: tokens.spacing.xxl,
          bottom: isLastSection ? tokens.spacing.xxl + 100 : tokens.spacing.xxl, // Extra padding for last section
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Section Header
            if (title != null) ...[
              Center(
                child: Column(
                  children: [
                    Text(
                      title!,
                      style: tokens.text.sectionTitle,
                      textAlign: TextAlign.center,
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: tokens.spacing.sm),
                      Text(
                        subtitle!,
                        style: tokens.text.bodyLarge?.copyWith(
                          color: tokens.color.onSurfaceWithOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: tokens.spacing.xxl),
            ],

            // Section Content
            Center(child: body),
          ],
        ),
      ),
    );
  }
}
