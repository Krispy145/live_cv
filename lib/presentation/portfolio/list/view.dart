import "package:auto_route/auto_route.dart";
import "package:cv_app/navigation/routes.gr.dart";
import "package:cv_package/data/models/portfolio_model.dart";
import "package:cv_package/presentation/portfolio/list_store.dart";
import "package:flutter/material.dart";
import "package:utilities/layouts/paginated_list/builder.dart";

/// [PortfoliosView] of the app.
class PortfoliosView extends StatelessWidget {
  /// [PortfoliosView] constructor.
  PortfoliosView({super.key});

  /// [store] is an instance of [PortfoliosStore], used in the [PaginatedListBuilder].
  final PortfoliosStore store = PortfoliosStore();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PaginatedListBuilder<PortfolioModel, String>.listView(
        store: store,
        itemBuilder: (context, index, portfolioModel) {
          return ListTile(
            title: Text(portfolioModel.id),
            onTap: () => context.navigateTo(
              PortfolioRoute(
                id: portfolioModel.id,
                portfolioModel: portfolioModel,
              ),
            ),
          );
        },
      ),
    );
  }
}
