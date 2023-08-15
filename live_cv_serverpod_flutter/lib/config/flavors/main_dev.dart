import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/flavors/flavor_config.dart';
import 'package:live_cv_serverpod_flutter/main_entry.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  final FlavorConfig flavorConfig = FlavorConfig(
    environment: Environment.dev,
    client: Client('http://localhost:8080/')..connectivityMonitor = FlutterConnectivityMonitor(),
  );
  setPathUrlStrategy();
  mainEntry(flavorConfig: flavorConfig);
}
