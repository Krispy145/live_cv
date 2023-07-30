import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/logger/logger.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ScreenSize {
  final double width;
  final double height;
  const ScreenSize({required this.width, required this.height});

  double dimension(Axis axis) => axis == Axis.vertical ? height : width;
  static final Size _size = MediaQuery.sizeOf(Managers.navigationService.mainContext);

  static bool get isMobile => getDeviceType(_size) == DeviceScreenType.mobile;
  static bool get isDesktop => getDeviceType(_size) == DeviceScreenType.desktop;
  static bool get isTablet => getDeviceType(_size) == DeviceScreenType.tablet;

  static T valueForScreen<T>({required T mobile, T? tablet, T? desktop}) {
    Logger.print("Calling valueForScreen", [LoggerFeature.navigation]);
    if (isDesktop && desktop != null) return desktop;
    if ((isTablet || isDesktop) && tablet != null) return tablet;
    return mobile;
  }
}

class ScreenSizes {
  static const small = ScreenSize(width: 320, height: 667);
  static const medium = ScreenSize(width: 375, height: 812);
  static const large = ScreenSize(width: 428, height: 926);

  static List<ScreenSize> get ordered => [small, medium, large];
}

double get screenWidth => MediaQuery.sizeOf(Managers.navigationService.mainContext).width;
double get screenHeight => MediaQuery.sizeOf(Managers.navigationService.mainContext).height;
