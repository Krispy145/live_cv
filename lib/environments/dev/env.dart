import "package:envied/envied.dart";
import "package:utilities/flavors/flavor_config.dart";

part "env.g.dart";

/// Dev Environment
@Envied(path: "lib/environments/dev/.env", name: "DevEnv")
class DevEnv implements Env {
  /// Name of the environment
  @EnviedField(obfuscate: true)
  static final String name = _DevEnv.name;

  /// domain of the environment
  @EnviedField(obfuscate: true)
  static final String domain = _DevEnv.domain;
}
