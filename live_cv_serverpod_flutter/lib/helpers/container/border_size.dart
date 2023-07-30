/// An enum used to specify the border size of an object.
enum AppBorderSize {
  none,
  xxs,
  xs,
  s,
  m,
  l,
  xl;

  /// Returns the width for a given size.
  double get width {
    switch (this) {
      case AppBorderSize.none:
        return 0;
      case AppBorderSize.xxs:
        return 1;
      case AppBorderSize.xs:
        return 2;
      case AppBorderSize.s:
        return 4;
      case AppBorderSize.m:
        return 6;
      case AppBorderSize.l:
        return 8;
      case AppBorderSize.xl:
        return 12;
    }
  }
}
