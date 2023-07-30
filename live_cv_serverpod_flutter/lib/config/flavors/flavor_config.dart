import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';

enum Environment { dev, prod }

class FlavorConfig {
  final Environment environment;
  final Client client;

  FlavorConfig({required this.environment, required this.client});
}
