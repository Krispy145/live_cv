import "package:auto_route/auto_route.dart";
import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/presentation/components/experience_card.dart";
import "package:cv_app/presentation/components/header_view.dart";
import "package:cv_app/presentation/components/location_map_bottom_sheet.dart";
import "package:cv_app/presentation/components/skills.dart";
import "package:cv_app/presentation/components/timeline_editor_dialog.dart";
import "package:cv_app/presentation/github/github_repo_card.dart";
import "package:cv_app/presentation/github/github_state.dart";
import "package:cv_app/presentation/github/roadmap_card.dart";
import "package:cv_app/presentation/landing/components/radial_contact_menu.dart";
import "package:cv_app/presentation/landing/components/section_builder.dart";
import "package:cv_app/presentation/landing/store.dart";
import "package:cv_app/utils/loggers.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";
import "package:url_launcher/url_launcher.dart";
import "package:utilities/data/sources/source.dart";
import "package:utilities/logger/logger.dart";
import "package:utilities/widgets/load_state/builder.dart";

// Global key to access the ScrollablePositionedList
final GlobalKey _scrollableListKey = GlobalKey();

/// [LandingView] of the app.
@RoutePage()
class LandingView extends StatefulWidget {
  /// [LandingView] constructor.
  const LandingView({super.key});

  @override
  State<LandingView> createState() => _LandingViewState();
}

class _LandingViewState extends State<LandingView> {
  /// [store] is an instance of [LandingStore], used in the [ScrollablePositionedList].
  /// Retrieved from dependency injection to ensure singleton behavior.
  LandingStore get store => Managers.landingStore;
  late final appWrapperStore = Managers.appWrapperStore;

  HeaderModel get headerModel => Managers.appWrapperStore.headerModel;

  @override
  void initState() {
    super.initState();
    // Auto-load GitHub data when the landing page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGitHubData();
    });
  }

  void _loadGitHubData() {
    // Use a delayed approach to ensure providers are fully initialized
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;

      try {
        final container = ProviderScope.containerOf(context);
        final githubNotifier = container.read(githubNotifierProvider.notifier);
        final githubState = container.read(githubNotifierProvider);

        AppLogger.print("Landing View GitHub Loading Debug:", [CVAppLoggers.github]);
        AppLogger.print("- isInitialized: ${githubNotifier.isInitialized}", [CVAppLoggers.github]);
        AppLogger.print("- isLoading: ${githubState.isLoading}", [CVAppLoggers.github]);
        AppLogger.print("- allRepos count: ${githubState.allRepos.length}", [CVAppLoggers.github]);
        AppLogger.print("- error: ${githubState.error}", [CVAppLoggers.github]);

        // Load if not already loading and no data exists
        if (githubNotifier.isInitialized && !githubState.isLoading && githubState.allRepos.isEmpty) {
          AppLogger.print("Triggering GitHub data load from LandingView", [CVAppLoggers.github]);
          githubNotifier.loadRepositories();
        } else if (githubState.error != null) {
          AppLogger.print("GitHub error detected, retrying in 3 seconds", [CVAppLoggers.github]);
          // Retry if there was an error
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              _loadGitHubData();
            }
          });
        } else if (!githubNotifier.isInitialized) {
          AppLogger.print("GitHub notifier not initialized yet, retrying in 1 second", [CVAppLoggers.github]);
          // Retry if notifier is not initialized yet
          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) {
              _loadGitHubData();
            }
          });
        } else {
          AppLogger.print("GitHub data already loaded or loading, skipping", [CVAppLoggers.github]);
        }
      } catch (e) {
        AppLogger.print("GitHub loading error in LandingView: $e", [CVAppLoggers.github]);
        // Handle error silently - GitHub data is optional
        // Retry after a delay if there was an error
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            _loadGitHubData();
          }
        });
      }
    });
  }

  Future<void> _editTimeline({required bool isEducation, TimelineModel? initial}) async {
    final entry = await TimelineEditorDialog.show(
      context,
      isEducation: isEducation,
      initial: initial,
    );
    if (entry == null || !mounted) {
      return;
    }
    final response = isEducation ? await appWrapperStore.upsertEducation(entry) : await appWrapperStore.upsertExperience(entry);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response == RequestResponse.success
              ? (isEducation ? "Education saved." : "Experience saved.")
              : "Could not save to Firestore.",
        ),
      ),
    );
  }

  Future<void> _deleteTimeline({
    required String id,
    required bool isEducation,
    required String title,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: false,
      builder: (context) => AlertDialog(
        title: Text(isEducation ? "Delete education?" : "Delete experience?"),
        content: Text("Remove \"$title\" from this CV?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Delete")),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    final response = await appWrapperStore.removeTimeline(id: id, isEducation: isEducation);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response == RequestResponse.success ? "Removed." : "Could not update Firestore."),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PackageLoadStateBuilder(
        store: appWrapperStore,
        loadedBuilder: (context) {
          return Consumer(
            builder: (context, ref, child) {
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
          headerModel: headerModel.copyWith(userDetails: appWrapperStore.userDetails),
        );
      case LandingOption.experience:
        return Observer(
          builder: (context) {
            final canEdit = Managers.config.showDevTools;
            final items = appWrapperStore.userDetails?.experience ?? const [];
            return SectionBuilder(
              title: "Professional Experience",
              subtitle: "My career journey and achievements",
              headerAction: canEdit
                  ? FilledButton.icon(
                      onPressed: () => _editTimeline(isEducation: false),
                      icon: const Icon(Icons.add),
                      label: const Text("Add experience"),
                    )
                  : null,
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: items
                        .asMap()
                        .entries
                        .map<Widget>(
                          (entry) => ExperienceCard(
                            timelineModel: entry.value,
                            index: entry.key,
                            isLast: entry.key == items.length - 1,
                            onEdit: canEdit ? () => _editTimeline(isEducation: false, initial: entry.value) : null,
                            onDelete: canEdit ? () => _deleteTimeline(id: entry.value.id, isEducation: false, title: entry.value.title) : null,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          },
        );

      case LandingOption.education:
        return Observer(
          builder: (context) {
            final canEdit = Managers.config.showDevTools;
            final items = appWrapperStore.userDetails?.education ?? const [];
            return SectionBuilder(
              title: "Education & Certifications",
              subtitle: "Academic background and professional qualifications",
              headerAction: canEdit
                  ? FilledButton.icon(
                      onPressed: () => _editTimeline(isEducation: true),
                      icon: const Icon(Icons.add),
                      label: const Text("Add education"),
                    )
                  : null,
              body: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    children: items
                        .asMap()
                        .entries
                        .map<Widget>(
                          (entry) => EducationCard(
                            timelineModel: entry.value,
                            index: entry.key,
                            isLast: entry.key == items.length - 1,
                            onEdit: canEdit ? () => _editTimeline(isEducation: true, initial: entry.value) : null,
                            onDelete: canEdit ? () => _deleteTimeline(id: entry.value.id, isEducation: true, title: entry.value.title) : null,
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            );
          },
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
          body: Consumer(
            builder: (context, ref, child) {
              final githubState = ref.watch<GitHubState>(githubNotifierProvider);

              if (githubState.roadmapData != null) {
                return RoadmapCard(
                  data: githubState.roadmapData!,
                  username: ref.watch(githubUsernameProvider),
                );
              } else if (githubState.isLoadingRoadmap) {
                return Container(
                  padding: EdgeInsets.all(tokens.spacing.xl),
                  decoration: BoxDecoration(
                    color: tokens.color.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(tokens.card.borderRadius),
                    border: Border.all(
                      color: tokens.color.outline.withValues(alpha: 0.2),
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
                      SizedBox(height: tokens.spacing.md),
                      ElevatedButton.icon(
                        onPressed: () {
                          final notifier = ref.read(githubNotifierProvider.notifier);
                          if (notifier.isInitialized) {
                            notifier.loadRepositories();
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text("Retry"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tokens.color.primary,
                          foregroundColor: tokens.color.onPrimary,
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
                      color: tokens.color.outline.withValues(alpha: 0.2),
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
                      SizedBox(height: tokens.spacing.md),
                      ElevatedButton.icon(
                        onPressed: () {
                          final notifier = ref.read(githubNotifierProvider.notifier);
                          if (notifier.isInitialized) {
                            notifier.loadRepositories();
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text("Retry"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tokens.color.primary,
                          foregroundColor: tokens.color.onPrimary,
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
                      SizedBox(height: tokens.spacing.md),
                      ElevatedButton.icon(
                        onPressed: () {
                          final notifier = ref.read(githubNotifierProvider.notifier);
                          if (notifier.isInitialized) {
                            notifier.loadRepositories();
                          }
                        },
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text("Retry"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: tokens.color.primary,
                          foregroundColor: tokens.color.onPrimary,
                        ),
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
        // Show location on map in bottom sheet
        if (userDetails.location != null) {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => LocationMapBottomSheet(
              location: userDetails.location!,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Location information not available"),
              duration: Duration(seconds: 3),
            ),
          );
        }
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
