/// GENERATED CODE - DO NOT MODIFY BY HAND
/// *****************************************************
///  FlutterGen
/// *****************************************************

// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: directives_ordering,unnecessary_import,implicit_dynamic_list_literal,deprecated_member_use

import 'package:flutter/widgets.dart';

class $AssetsImagesGen {
  const $AssetsImagesGen();

  /// File path: assets/images/avatar.png
  AssetGenImage get avatar => const AssetGenImage('assets/images/avatar.png');

  /// File path: assets/images/logo-icon-bg.png
  AssetGenImage get logoIconBg => const AssetGenImage('assets/images/logo-icon-bg.png');

  /// File path: assets/images/logo-icon-name-bottom.png
  AssetGenImage get logoIconNameBottom => const AssetGenImage('assets/images/logo-icon-name-bottom.png');

  /// File path: assets/images/logo-icon-name-left-bg.png
  AssetGenImage get logoIconNameLeftBg => const AssetGenImage('assets/images/logo-icon-name-left-bg.png');

  /// File path: assets/images/logo-icon-name-left.png
  AssetGenImage get logoIconNameLeft => const AssetGenImage('assets/images/logo-icon-name-left.png');

  /// File path: assets/images/logo-icon-name-right-bg.png
  AssetGenImage get logoIconNameRightBg => const AssetGenImage('assets/images/logo-icon-name-right-bg.png');

  /// File path: assets/images/logo-icon-name-right.png
  AssetGenImage get logoIconNameRight => const AssetGenImage('assets/images/logo-icon-name-right.png');

  /// File path: assets/images/logo-icon-name-top-bg.png
  AssetGenImage get logoIconNameTopBg => const AssetGenImage('assets/images/logo-icon-name-top-bg.png');

  /// File path: assets/images/logo-icon-name-top.png
  AssetGenImage get logoIconNameTop => const AssetGenImage('assets/images/logo-icon-name-top.png');

  /// File path: assets/images/logo-icon.png
  AssetGenImage get logoIcon => const AssetGenImage('assets/images/logo-icon.png');

  /// File path: assets/images/logo-name-bg.png
  AssetGenImage get logoNameBg => const AssetGenImage('assets/images/logo-name-bg.png');

  /// File path: assets/images/logo-name.png
  AssetGenImage get logoName => const AssetGenImage('assets/images/logo-name.png');

  /// File path: assets/images/skate-oasis-circle.png
  AssetGenImage get skateOasisCircle => const AssetGenImage('assets/images/skate-oasis-circle.png');

  /// File path: assets/images/skate-oasis-square.png
  AssetGenImage get skateOasisSquare => const AssetGenImage('assets/images/skate-oasis-square.png');

  /// List of all assets
  List<AssetGenImage> get values => [
        avatar,
        logoIconBg,
        logoIconNameBottom,
        logoIconNameLeftBg,
        logoIconNameLeft,
        logoIconNameRightBg,
        logoIconNameRight,
        logoIconNameTopBg,
        logoIconNameTop,
        logoIcon,
        logoNameBg,
        logoName,
        skateOasisCircle,
        skateOasisSquare
      ];
}

class $AssetsThemesGen {
  const $AssetsThemesGen();

  /// File path: assets/themes/base_theme.json
  String get baseTheme => 'assets/themes/base_theme.json';

  /// File path: assets/themes/components_theme.json
  String get componentsTheme => 'assets/themes/components_theme.json';

  /// List of all assets
  List<String> get values => [baseTheme, componentsTheme];
}

class Assets {
  const Assets._();

  static const $AssetsImagesGen images = $AssetsImagesGen();
  static const $AssetsThemesGen themes = $AssetsThemesGen();
}

class AssetGenImage {
  const AssetGenImage(
    this._assetName, {
    this.size,
    this.flavors = const {},
  });

  final String _assetName;

  final Size? size;
  final Set<String> flavors;

  Image image({
    Key? key,
    AssetBundle? bundle,
    ImageFrameBuilder? frameBuilder,
    ImageErrorWidgetBuilder? errorBuilder,
    String? semanticLabel,
    bool excludeFromSemantics = false,
    double? scale,
    double? width,
    double? height,
    Color? color,
    Animation<double>? opacity,
    BlendMode? colorBlendMode,
    BoxFit? fit,
    AlignmentGeometry alignment = Alignment.center,
    ImageRepeat repeat = ImageRepeat.noRepeat,
    Rect? centerSlice,
    bool matchTextDirection = false,
    bool gaplessPlayback = true,
    bool isAntiAlias = false,
    String? package,
    FilterQuality filterQuality = FilterQuality.medium,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.asset(
      _assetName,
      key: key,
      bundle: bundle,
      frameBuilder: frameBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      scale: scale,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      isAntiAlias: isAntiAlias,
      package: package,
      filterQuality: filterQuality,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }

  ImageProvider provider({
    AssetBundle? bundle,
    String? package,
  }) {
    return AssetImage(
      _assetName,
      bundle: bundle,
      package: package,
    );
  }

  String get path => _assetName;

  String get keyName => _assetName;
}
