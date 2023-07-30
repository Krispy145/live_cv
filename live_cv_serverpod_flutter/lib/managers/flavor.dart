import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/config/flavors/flavor_config.dart';

class FlavorManager extends ChangeNotifier {
  final FlavorConfig flavorConfig;

  FlavorManager({required this.flavorConfig});
}
