import "package:mobx/mobx.dart";
import "package:utilities/flavors/flavor_config.dart";

/// App flavor configuration used by [Managers] and the package injector.
class ConfigStore extends FlavorConfig {
  /// [ConfigStore] constructor.
  ConfigStore(
    String environmentName, {
    required super.loggerFeatures,
    super.overrideFeatures = false,
    bool showDevTools = false,
    required this.domain,
  })  : _showDevTools = Observable(showDevTools),
        super(
          environmentName: environmentName,
        );

  /// Public web domain for this flavor.
  final String domain;

  final Observable<bool> _showDevTools;

  /// Whether the development overlay is visible.
  bool get showDevTools => _showDevTools.value;
  set showDevTools(bool value) => _showDevTools.value = value;

  /// Toggles [showDevTools].
  void toggleDevTools() => showDevTools = !showDevTools;
}
