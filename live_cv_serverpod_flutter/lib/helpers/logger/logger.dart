import 'package:flutter/material.dart';

///Enum responsible for storing feature references.
enum LoggerFeature {
  navigation,
  dependencyInjection;

  ///Method responsible for determining whether logs should be printed.
  bool get shouldPrint {
    switch (this) {
      case LoggerFeature.navigation:
        return true;
      case LoggerFeature.dependencyInjection:
        return true;
    }
  }
}

///Class responsible for logging.
class Logger {
  ///Method responsible for printing log to the console.
  static void print(
    String text,
    List<LoggerFeature> features,
  ) {
    final List<String> activeFeatures = [];
    for (LoggerFeature feature in features) {
      if (feature.shouldPrint) {
        activeFeatures.add(feature.name.toUpperCase());
      }
    }
    if (activeFeatures.isNotEmpty) {
      debugPrint("Features (${activeFeatures.join(', ')}): $text");
    }
  }
}
