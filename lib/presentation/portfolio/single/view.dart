import "package:auto_route/auto_route.dart";
import "package:cv_package/data/models/portfolio_model.dart";
import "package:cv_package/presentation/portfolio/list_store.dart";
import "package:cv_package/presentation/portfolio/single_store.dart";
import "package:flutter/material.dart";
import "package:utilities/widgets/load_state/builder.dart";

/// [PortfolioView] of the app.
@RoutePage()
class PortfolioView extends StatelessWidget {
  final String? id;
  final PortfolioModel? portfolioModel;

  /// [PortfolioView] constructor.
  PortfolioView({super.key, this.id, this.portfolioModel})
      : assert(
          id != null || portfolioModel != null,
          "id or portfolioModel must be provided.",
        ),
        store = PortfolioStore(id: id, initialPortfolioModel: portfolioModel);

  /// [store] is an instance of [PortfoliosStore], used in the [PackageLoadStateBuilder].
  /// initialized in the constructor.
  final PortfolioStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PackageLoadStateBuilder(
        store: store,
        loadedBuilder: (context) => Text(store.currentPortfolio!.id),
      ),
    );
  }
}
