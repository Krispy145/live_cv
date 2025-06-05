import "package:envied/envied.dart";
import "package:utilities/flavors/flavor_config.dart";

part "env.g.dart";

/// Prod Environment
@Envied(path: "lib/environments/prod/.env", name: "ProdEnv")
class ProdEnv implements Env {
  /// Name of the environment
  @EnviedField(obfuscate: true)
  static final String name = _ProdEnv.name;

  /// domain of the environment
  @EnviedField(obfuscate: true)
  static final String domain = _ProdEnv.domain;
}
