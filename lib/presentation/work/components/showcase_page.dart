import "package:cv_app/core/theme/theme_tokens.dart";
import "package:flutter/material.dart";

/// Shared max-width page padding for Work / Engineering / About.
class ShowcasePage extends StatelessWidget {
  /// [ShowcasePage] constructor.
  const ShowcasePage({
    super.key,
    required this.child,
    this.maxWidth = 1100,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.fromLTRB(tokens.spacing.xl, tokens.spacing.xxl, tokens.spacing.xl, tokens.spacing.xxl + 80),
          child: child,
        ),
      ),
    );
  }
}

/// Hairline section divider used between selected-work rows.
class ShowcaseRule extends StatelessWidget {
  /// [ShowcaseRule] constructor.
  const ShowcaseRule({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return Divider(height: tokens.spacing.xxl, color: tokens.color.outline.withValues(alpha: 0.18));
  }
}
