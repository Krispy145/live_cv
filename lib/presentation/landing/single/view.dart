import "package:auto_route/auto_route.dart";
import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/data/showcase/showcase_catalog.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/navigation/routes.gr.dart";
import "package:cv_app/presentation/components/header_view.dart";
import "package:cv_app/presentation/work/components/featured_work_card.dart";
import "package:cv_app/presentation/work/components/showcase_page.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";
import "package:utilities/widgets/load_state/builder.dart";

/// Portfolio landing: hero + selected work.
@RoutePage()
class LandingView extends StatefulWidget {
  /// [LandingView] constructor.
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  late final _appStore = Managers.appWrapperStore;
  final _workKey = GlobalKey();

  HeaderModel get headerModel => _appStore.headerModel;

  void _scrollToWork() {
    final context = _workKey.currentContext;
    if (context == null) {
      return;
    }
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _openGithub() async {
    final url = headerModel.userDetails.githubUrl;
    if (url == null) {
      return;
    }
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PackageLoadStateBuilder(
      store: _appStore,
      loadedBuilder: (context) {
        final tokens = ThemeTokens.of(context);
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: HeaderView(
                    headerModel: headerModel.copyWith(userDetails: _appStore.userDetails),
                    onExploreWork: _scrollToWork,
                    onOpenGithub: _openGithub,
                  ),
                ),
              ),
              ShowcasePage(
                child: Column(
                  key: _workKey,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selected work",
                      style: tokens.text.bodySmall?.copyWith(
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w700,
                        color: tokens.color.onSurfaceWithOpacity(0.5),
                      ),
                    ),
                    ...ShowcaseCatalog.featured.map(
                      (study) => FeaturedWorkCard(
                        study: study,
                        onOpen: () => context.router.push(CaseStudyRoute(slug: study.slug)),
                      ),
                    ),
                    const ShowcaseRule(),
                    TextButton(
                      onPressed: () => context.router.navigate(const ProjectsRoute()),
                      child: const Text("Other work  →"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
