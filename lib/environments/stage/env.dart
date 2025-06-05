import "package:envied/envied.dart";
import "package:utilities/flavors/flavor_config.dart";

part "env.g.dart";

/// Stage Environment
@Envied(path: "lib/environments/stage/.env", name: "StageEnv")
class StageEnv implements Env {
  /// Name of the environment
  @EnviedField(obfuscate: true)
  static final String name = _StageEnv.name;

  /// domain of the environment
  @EnviedField(obfuscate: true)
  static final String domain = _StageEnv.domain;
}
