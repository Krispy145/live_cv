import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/flavors/flavor_config.dart';
import 'package:live_cv_serverpod_flutter/main_entry.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

void main() {
  final FlavorConfig flavorConfig = FlavorConfig(
    environment: Environment.dev,
    client: Client('http://localhost:8080/')..connectivityMonitor = FlutterConnectivityMonitor(),
  );
  // flavorConfig.client.description.insert(
  //   Description(header: "About", subheader: "A brief overview", paragraph: aboutParagraph, type: DescriptionType.about.name,),
  // );

  mainEntry(flavorConfig: flavorConfig);
}
