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
class AppWrapperView extends StatefulWidget {
  /// [AppWrapperView] constructor.
  const AppWrapperView({super.key});

  @override
  State<AppWrapperView> createState() => _AppWrapperViewState();
}

class _AppWrapperViewState extends State<AppWrapperView> {
  final AppStore store = Managers.appWrapperStore;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeStore();
  }

  Future<void> _initializeStore() async {
    await store.initialize();
    if (mounted) {
      setState(() {
        _isInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
