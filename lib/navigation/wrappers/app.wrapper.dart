import "package:auto_route/auto_route.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/navigation/components/app_bar.dart";
import "package:cv_app/navigation/wrappers/store.dart";
import "package:flutter/material.dart";
import "package:navigation/structures/default/widget.dart";
import "package:utilities/widgets/load_state/builder.dart";

/// [AppWrapperView] is a class that defines the default wrapper of the app
/// This returns the selected app structure.
@RoutePage()
class AppWrapperView extends StatelessWidget {
  /// [AppWrapperView] constructor.
  AppWrapperView({super.key});

  final AppStore store = Managers.appWrapperStore..initialize();

  @override
  Widget build(BuildContext context) {
    return PackageLoadStateBuilder(
      store: store,
      loadedBuilder: (context) {
        return DefaultShellStructure(
          appBar: MainAppBar(title: store.userDetails!.fullName),
          store: store.appWrapperStore,
        );
      },
    );
  }
}
