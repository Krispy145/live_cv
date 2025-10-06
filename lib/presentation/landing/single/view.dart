import "package:auto_route/auto_route.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/features/github/presentation/github_repo_card.dart";
import "package:cv_app/features/github/presentation/roadmap_card.dart";
import "package:cv_app/features/github/state/github_state.dart";
import "package:cv_app/presentation/components/header_view.dart";
import "package:cv_app/presentation/landing/components/radial_contact_menu.dart";
import "package:cv_app/presentation/landing/components/section_builder.dart";
import "package:cv_package/core/theme/theme_tokens.dart";
import "package:cv_package/data/models/header_model.dart";
import "package:cv_package/presentation/components/experience_card.dart";
import "package:cv_package/presentation/components/skills.dart";
import "package:cv_package/presentation/landing/store.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";
import "package:url_launcher/url_launcher.dart";
import "package:utilities/widgets/load_state/builder.dart";

// Global key to access the ScrollablePositionedList
final GlobalKey _scrollableListKey = GlobalKey();

/// [LandingView] of the app.
@RoutePage()
class LandingView extends StatelessWidget {
  /// [LandingView] constructor.
  LandingView({super.key});

  /// [store] is an instance of [LandingStore], used in the [ScrollablePositionedList].
  /// Retrieved from dependency injection to ensure singleton behavior.
  LandingStore get store => Managers.landingStore;
  late final appWrapperStore = Managers.appWrapperStore;

  HeaderModel get headerModel => Managers.appWrapperStore.headerModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PackageLoadStateBuilder(
        store: appWrapperStore,
        loadedBuilder: (context) {
          return Consumer(
            builder: (context, ref, child) {
              // Auto-load GitHub data when the landing page loads
              WidgetsBinding.instance.addPostFrameCallback((_) {
                try {
                  final githubNotifier = ref.read(githubNotifierProvider.notifier);
                  final githubState = ref.read(githubNotifierProvider);

                  // Load if not already loading and no data exists
                  if (githubNotifier.isInitialized && !githubState.isLoading && githubState.allRepos.isEmpty) {
                    githubNotifier.loadRepositories();
                  }
                } catch (e) {
                  // Handle error silently
                }
              });

              return Stack(
                children: [
                  ScrollablePositionedList.builder(
                    key: _scrollableListKey,
                    itemCount: LandingOption.values.length,
                    itemBuilder: _buildItem,
                    itemScrollController: store.itemScrollController,
                    scrollOffsetController: store.scrollOffsetController,
                    itemPositionsListener: store.itemPositionsListener,
                    scrollOffsetListener: store.scrollOffsetListener,
                  ),
                  _buildFloatingContactButton(context),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final tokens = ThemeTokens.of(context);
    final option = LandingOption.values[index];

    switch (option) {
      case LandingOption.header:
        return HeaderView(
          headerModel: headerModel,
        );
      case LandingOption.experience:
        return SectionBuilder(
          title: "Professional Experience",
          subtitle: "My career journey and achievements",
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: Column(
                children: appWrapperStore.userDetails!.experience
                    .asMap()
                    .entries
                    .map<Widget>(
                      (entry) => ExperienceCard(
                        timelineModel: entry.value,
                        index: entry.key,
                        isLast: entry.key == appWrapperStore.userDetails!.experience.length - 1,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );

      case LandingOption.education:
        return SectionBuilder(
          title: "Education & Certifications",
          subtitle: "Academic background and professional qualifications",
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 800,
              ),
              child: Column(
                children: appWrapperStore.userDetails!.education
                    .asMap()
                    .entries
                    .map<Widget>(
                      (entry) => EducationCard(
                        timelineModel: entry.value,
                        index: entry.key,
                        isLast: entry.key == appWrapperStore.userDetails!.education.length - 1,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        );
      case LandingOption.skills:
        return SectionBuilder(
          title: "Technical Skills",
          subtitle: "Technologies and tools I work with",
          body: SkillsBuilder(
            skills: headerModel.skillsPairs,
          ),
        );
      case LandingOption.roadmap:
        return SectionBuilder(
          title: "AI + Cybersecurity Roadmap",
          subtitle: "My learning journey and current focus areas",
          body: Consumer(
            builder: (context, ref, child) {
              final githubState = ref.watch<GitHubState>(githubNotifierProvider);

              if (githubState.roadmapData != null) {
                return RoadmapCard(
                  data: githubState.roadmapData!,
                  onViewMilestones: () {
                    // Handle view milestones action
                    debugPrint("View Milestones");
                  },
                );
              } else if (githubState.isLoadingRoadmap) {
                return Container(
                  padding: EdgeInsets.all(tokens.spacing.xl),
                  decoration: BoxDecoration(
                    color: tokens.color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(tokens.card.borderRadius),
                    border: Border.all(
                      color: tokens.color.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: tokens.color.primary),
                      SizedBox(height: tokens.spacing.md),
                      Text(
                        "Loading roadmap data...",
                        style: tokens.text.titleMedium,
                      ),
                      SizedBox(height: tokens.spacing.sm),
                      Text(
                        "Fetching roadmap information from GitHub",
                        style: tokens.text.bodyMedium?.copyWith(
                          color: tokens.color.onSurfaceWithOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                // No roadmap data available
                return Container(
                  padding: EdgeInsets.all(tokens.spacing.xl),
                  decoration: BoxDecoration(
                    color: tokens.color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(tokens.card.borderRadius),
                    border: Border.all(
                      color: tokens.color.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.timeline,
                        size: 48,
                        color: tokens.color.primary,
                      ),
                      SizedBox(height: tokens.spacing.md),
                      Text(
                        "Roadmap Coming Soon",
                        style: tokens.text.titleMedium,
                      ),
                      SizedBox(height: tokens.spacing.sm),
                      Text(
                        "My learning roadmap will be available here soon",
                        style: tokens.text.bodyMedium?.copyWith(
                          color: tokens.color.onSurfaceWithOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        );
      case LandingOption.portfolio:
        return SectionBuilder(
          title: "GitHub Projects",
          subtitle: "My open source repositories and contributions",
          isLastSection: true,
          body: Consumer(
            builder: (context, ref, child) {
              final githubState = ref.watch<GitHubState>(githubNotifierProvider);

              if (githubState.isLoading && githubState.allRepos.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(color: tokens.color.primary),
                      SizedBox(height: tokens.spacing.md),
                      Text(
                        "Loading repositories...",
                        style: tokens.text.bodyMedium?.copyWith(
                          color: tokens.color.onSurfaceWithOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (githubState.error != null && githubState.allRepos.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: tokens.color.error,
                      ),
                      SizedBox(height: tokens.spacing.md),
                      Text(
                        "Failed to load repositories",
                        style: tokens.text.titleMedium,
                      ),
                      SizedBox(height: tokens.spacing.sm),
                      Text(
                        githubState.error!,
                        style: tokens.text.bodyMedium?.copyWith(
                          color: tokens.color.onSurfaceWithOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              final repos = githubState.regularRepos;

              if (repos.isEmpty) {
                return Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.code,
                        size: 48,
                        color: tokens.color.primary,
                      ),
                      SizedBox(height: tokens.spacing.md),
                      Text(
                        "No repositories found",
                        style: tokens.text.titleMedium,
                      ),
                      SizedBox(height: tokens.spacing.sm),
                      Text(
                        "Check back later for new projects",
                        style: tokens.text.bodyMedium?.copyWith(
                          color: tokens.color.onSurfaceWithOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: repos
                      .map<Widget>(
                        (repo) => Padding(
                          padding: EdgeInsets.only(right: tokens.spacing.lg),
                          child: SizedBox(
                            width: 300,
                            child: GitHubRepoCard(
                              repo: repo,
                              username: ref.watch(githubUsernameProvider),
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              );
            },
          ),
        );

      case LandingOption.contact:
        return const SizedBox.shrink();
    }
  }

  Widget _buildFloatingContactButton(BuildContext context) {
    return Positioned(
      bottom: 32,
      right: 32,
      child: RadialContactMenu(
        onContactSelected: (contactType) => _handleContactAction(context, contactType),
      ),
    );
  }

  void _handleContactAction(BuildContext context, ContactType contactType) {
    final userDetails = headerModel.userDetails;

    switch (contactType) {
      case ContactType.email:
        if (userDetails.email != null) {
          _launchUrl("mailto:${userDetails.email}");
        }
        break;
      case ContactType.phone:
        if (userDetails.phone != null) {
          _launchUrl("tel:${userDetails.phone}");
        }
        break;
      case ContactType.github:
        if (userDetails.githubUrl != null) {
          _launchUrl(userDetails.githubUrl!);
        }
        break;
      case ContactType.linkedin:
        if (userDetails.linkedinUrl != null) {
          _launchUrl(userDetails.linkedinUrl!);
        }
        break;
      case ContactType.location:
        // Show location info in a snackbar or dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Location: ${userDetails.location?.toString() ?? 'Not available'}"),
            duration: const Duration(seconds: 3),
          ),
        );
        break;
    }
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
