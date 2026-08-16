import "package:flutter/material.dart";

/// Design tokens derived from the current [ThemeData].
class ThemeTokens {
  ThemeTokens._(this.context) : theme = Theme.of(context);

  /// Resolves tokens from the nearest [Theme].
  factory ThemeTokens.of(BuildContext context) => ThemeTokens._(context);

  /// The originating [BuildContext].
  final BuildContext context;

  /// The resolved [ThemeData].
  final ThemeData theme;

  /// Color tokens.
  late final ThemeColorTokens color = ThemeColorTokens(theme.colorScheme);

  /// Typography tokens.
  late final ThemeTextTokens text = ThemeTextTokens(theme.textTheme);

  /// Spacing tokens.
  final ThemeSpacingTokens spacing = const ThemeSpacingTokens();

  /// Card tokens.
  late final ThemeCardTokens card = ThemeCardTokens(theme);

  /// Chip tokens.
  late final ThemeChipTokens chip = ThemeChipTokens(theme);
}

/// Color design tokens.
class ThemeColorTokens {
  /// [ThemeColorTokens] constructor.
  const ThemeColorTokens(this.scheme);

  /// Underlying color scheme.
  final ColorScheme scheme;

  /// Primary brand color.
  Color get primary => scheme.primary;

  /// Color drawn on [primary].
  Color get onPrimary => scheme.onPrimary;

  /// Surface color.
  Color get surface => scheme.surface;

  /// Color drawn on [surface].
  Color get onSurface => scheme.onSurface;

  /// Highest-emphasis surface container.
  Color get surfaceContainerHighest => scheme.surfaceContainerHighest;

  /// Outline / divider color.
  Color get outline => scheme.outline;

  /// Error color.
  Color get error => scheme.error;

  /// [onSurface] with the given [opacity].
  Color onSurfaceWithOpacity(double opacity) => scheme.onSurface.withValues(alpha: opacity);
}

/// Spacing design tokens.
class ThemeSpacingTokens {
  /// [ThemeSpacingTokens] constructor.
  const ThemeSpacingTokens();

  /// Extra-small spacing.
  double get xs => 4;

  /// Small spacing.
  double get sm => 8;

  /// Medium spacing.
  double get md => 16;

  /// Large spacing.
  double get lg => 24;

  /// Extra-large spacing.
  double get xl => 32;

  /// Extra-extra-large spacing.
  double get xxl => 48;
}

/// Typography design tokens.
class ThemeTextTokens {
  /// [ThemeTextTokens] constructor.
  const ThemeTextTokens(this._textTheme);

  final TextTheme _textTheme;

  /// Hero title used on the landing header.
  TextStyle get heroTitle =>
      _textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, height: 1.1) ??
      const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, height: 1.1);

  /// Section title used by landing sections.
  TextStyle get sectionTitle =>
      _textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700) ??
      const TextStyle(fontSize: 28, fontWeight: FontWeight.w700);

  /// Chip label style.
  TextStyle get chipLabel => _textTheme.labelMedium ?? const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);

  /// Title large.
  TextStyle? get titleLarge => _textTheme.titleLarge;

  /// Title medium.
  TextStyle? get titleMedium => _textTheme.titleMedium;

  /// Title small.
  TextStyle? get titleSmall => _textTheme.titleSmall;

  /// Headline small.
  TextStyle? get headlineSmall => _textTheme.headlineSmall;

  /// Body large.
  TextStyle? get bodyLarge => _textTheme.bodyLarge;

  /// Body medium.
  TextStyle? get bodyMedium => _textTheme.bodyMedium;

  /// Body small.
  TextStyle? get bodySmall => _textTheme.bodySmall;
}

/// Card design tokens.
class ThemeCardTokens {
  /// [ThemeCardTokens] constructor.
  const ThemeCardTokens(this._theme);

  final ThemeData _theme;

  /// Default card corner radius.
  double get borderRadius {
    final shape = _theme.cardTheme.shape;
    if (shape is RoundedRectangleBorder) {
      final radius = shape.borderRadius;
      if (radius is BorderRadius) {
        return radius.topLeft.x;
      }
    }
    return 16;
  }
}

/// Chip design tokens.
class ThemeChipTokens {
  /// [ThemeChipTokens] constructor.
  const ThemeChipTokens(this._theme);

  final ThemeData _theme;

  /// Default chip label style.
  TextStyle get labelStyle => _theme.chipTheme.labelStyle ?? const TextStyle(fontSize: 12, fontWeight: FontWeight.w600);
}
