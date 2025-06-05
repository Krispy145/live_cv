import "package:auto_route/auto_route.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/presentation/components/header_view.dart";
import "package:cv_package/data/models/header_model.dart";
import "package:cv_package/presentation/components/contact.dart";
import "package:cv_package/presentation/components/portfolio.dart";
import "package:cv_package/presentation/components/skills.dart";
import "package:cv_package/presentation/components/timeline.dart";
import "package:cv_package/presentation/landing/store.dart";
import "package:flutter/material.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";
import "package:theme/extensions/build_context.dart";
import "package:utilities/helpers/extensions/build_context.dart";
import "package:utilities/widgets/load_state/builder.dart";

/// [LandingView] of the app.
@RoutePage()
class LandingView extends StatelessWidget {
  /// [LandingView] constructor.
  LandingView({super.key});

  /// [store] is an instance of [LandingStore], used in the [ScrollablePositionedList].
  /// initialized in the constructor.
  final LandingStore store = Managers.landingStore;
  final appWrapperStore = Managers.appWrapperStore;

  HeaderModel get headerModel => Managers.appWrapperStore.headerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PackageLoadStateBuilder(
        store: appWrapperStore,
        loadedBuilder: (context) {
          return ScrollablePositionedList.builder(
            itemCount: LandingOption.values.length,
            itemBuilder: _buildItem,
            itemScrollController: store.itemScrollController,
            scrollOffsetController: store.scrollOffsetController,
            itemPositionsListener: store.itemPositionsListener,
            scrollOffsetListener: store.scrollOffsetListener,
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final option = LandingOption.values[index];
    switch (option) {
      case LandingOption.header:
        return HeaderView(
          headerModel: headerModel,
        );
      case LandingOption.experience:
        return _buildSection(
          context,
          color: context.colorScheme.secondary,
          body: Column(
            children: appWrapperStore.userDetails!.experience
                .map<Widget>(
                  (experience) => TimelineBuilder.leftToRight(
                    timelineModel: experience,
                    backgroundColour: TimelineColor.secondary,
                  ),
                )
                .toList(),
          ),
        );

      case LandingOption.education:
        return _buildSection(
          context,
          color: context.colorScheme.primary,
          height: context.screenHeight * 0.3,
          body: Column(
            children: appWrapperStore.userDetails!.education.map<Widget>((education) => TimelineBuilder.rightToLeft(timelineModel: education)).toList(),
          ),
        );
      case LandingOption.skills:
        return _buildSection(
          context,
          height: context.screenHeight * 0.3,
          color: context.colorScheme.secondary,
          body: Center(
            child: SkillsBuilder(
              skills: headerModel.skillsPairs,
            ),
          ),
        );
      case LandingOption.portfolio:
        return _buildSection(
          context,
          color: context.colorScheme.primary,
          body: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: appWrapperStore.userDetails!.portfolio.map<Widget>((portfolio) => PortfolioBuilder(portfolio: portfolio)).toList(),
            ),
          ),
        );

      case LandingOption.contact:
        return const SizedBox.shrink();
      case LandingOption.footer:
        return _buildSection(
          context,
          height: context.screenHeight * 0.08,
          color: context.colorScheme.secondary,
          body: Center(
            child: ContactBuilder(
              userDetails: headerModel.userDetails,
            ),
          ),
        );
    }
  }

  ColoredBox _buildSection(BuildContext context, {required Widget body, required Color color, double? height}) {
    return ColoredBox(
      color: color,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: height ?? context.screenHeight,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Center(child: body),
        ),
      ),
    );
  }
}
