import "dart:async";

import "package:cv_app/features/github/presentation/github_repo_card.dart";
import "package:cv_app/features/github/presentation/github_repo_card_skeleton.dart";
import "package:cv_app/features/github/presentation/roadmap_card.dart";
import "package:cv_app/features/github/presentation/topic_filter_bar.dart";
import "package:cv_app/features/github/state/github_state.dart";
import "package:cv_package/core/theme/theme_tokens.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Main page for displaying GitHub repositories
class GitHubPage extends ConsumerStatefulWidget {
  const GitHubPage({super.key});

  @override
  ConsumerState<GitHubPage> createState() => _GitHubPageState();
}

class _GitHubPageState extends ConsumerState<GitHubPage> {
  final TextEditingController _searchController = TextEditingController();
  late final Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(milliseconds: 300));

    // Load repositories when page initializes (only if notifier is ready)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(githubNotifierProvider.notifier);
      // Only load if the notifier has a valid repository
      if (notifier.isInitialized) {
        notifier.loadRepositories();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final state = ref.watch(githubNotifierProvider);
    final notifier = ref.read(githubNotifierProvider.notifier);

    // Auto-load repositories when notifier becomes initialized
    if (notifier.isInitialized && state.allRepos.isEmpty && !state.isLoading && state.error == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.loadRepositories();
      });
    }

    // Handle loading state when repository is not yet initialized
    if (state.isLoading && state.allRepos.isEmpty && state.error == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Projects"),
        actions: [
          IconButton(
            onPressed: () => ref.read(githubNotifierProvider.notifier).refreshRepositories(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              // Search bar
              Padding(
                padding: tokens.spacing.sectionPadding,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search repositories...",
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              ref.read(githubNotifierProvider.notifier).setSearchQuery("");
                            },
                            icon: const Icon(Icons.clear),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    _debouncer.call(() {
                      ref.read(githubNotifierProvider.notifier).setSearchQuery(value);
                    });
                  },
                ),
              ),

              // Sort dropdown
              Padding(
                padding: tokens.spacing.sectionPadding,
                child: Row(
                  children: [
                    const Text("Sort by:"),
                    const SizedBox(width: 8),
                    DropdownButton<GitHubSortOption>(
                      value: state.sortOption,
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(githubNotifierProvider.notifier).setSortOption(value);
                        }
                      },
                      items: GitHubSortOption.values.map((option) {
                        return DropdownMenuItem(
                          value: option,
                          child: Text(_getSortOptionLabel(option)),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              // Topic filter bar
              const TopicFilterBar(),

              // Rate limit banner
              if (state.isRateLimited)
                Container(
                  width: double.infinity,
                  padding: tokens.spacing.sectionPadding,
                  color: Colors.orange.withOpacity(0.1),
                  child: Row(
                    children: [
                      const Icon(Icons.warning, color: Colors.orange),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error ?? "Rate limit exceeded. Please set a Personal Access Token.",
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                ),

              // Content
              Expanded(
                child: _buildContent(state),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(GitHubState state) {
    final tokens = ThemeTokens.of(context);

    if (state.isLoading && state.allRepos.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.error != null && state.allRepos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            SizedBox(height: tokens.spacing.lg),
            Text(
              "Failed to load repositories",
              style: tokens.text.headlineSmall,
            ),
            SizedBox(height: tokens.spacing.sm),
            Text(
              state.error!,
              textAlign: TextAlign.center,
              style: tokens.text.bodyMedium?.copyWith(
                color: tokens.color.onSurfaceWithOpacity(0.7),
              ),
            ),
            SizedBox(height: tokens.spacing.lg),
            ElevatedButton(
              onPressed: () => ref.read(githubNotifierProvider.notifier).loadRepositories(),
              child: const Text("Retry"),
            ),
          ],
        ),
      );
    }

    // Show roadmap repository separately if it exists
    final roadmapRepo = state.roadmapRepo;
    final regularRepos = state.regularRepos;

    return CustomScrollView(
      slivers: [
        // Roadmap section
        if (state.roadmapData != null) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: tokens.spacing.sectionPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Featured Project",
                    style: tokens.text.sectionTitle,
                  ),
                  SizedBox(height: tokens.spacing.lg),
                  RoadmapCard(
                    data: state.roadmapData!,
                    onViewMilestones: () {
                      // Handle view milestones action
                      debugPrint("View Milestones");
                    },
                  ),
                ],
              ),
            ),
          ),
        ] else if (roadmapRepo != null) ...[
          // Fallback to regular card if roadmap data is not available
          SliverToBoxAdapter(
            child: Padding(
              padding: tokens.spacing.sectionPadding,
              child: Text(
                "Featured Project",
                style: tokens.text.sectionTitle,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: GitHubRepoCard(
              repo: roadmapRepo,
              onViewRoadmap: () => _openRoadmap(roadmapRepo.htmlUrl),
            ),
          ),
        ],

        // Regular repositories section
        if (state.isLoading && regularRepos.isEmpty) ...[
          // Show skeleton loaders while loading
          SliverToBoxAdapter(
            child: Padding(
              padding: tokens.spacing.sectionPadding,
              child: Text(
                "Loading Projects...",
                style: tokens.text.sectionTitle,
              ),
            ),
          ),
          SliverPadding(
            padding: tokens.spacing.sectionPadding,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 1.4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => const GitHubRepoCardSkeleton(),
                childCount: 6, // Show 6 skeleton cards
              ),
            ),
          ),
        ] else if (regularRepos.isNotEmpty) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: tokens.spacing.sectionPadding,
              child: Text(
                "All Projects (${regularRepos.length})",
                style: tokens.text.sectionTitle,
              ),
            ),
          ),
          SliverPadding(
            padding: tokens.spacing.sectionPadding,
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 400,
                childAspectRatio: 1.4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final repo = regularRepos[index];
                  return GitHubRepoCard(repo: repo);
                },
                childCount: regularRepos.length,
              ),
            ),
          ),
        ],

        // Empty state
        if (regularRepos.isEmpty && roadmapRepo == null)
          SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.code, size: 64, color: Colors.grey),
                  SizedBox(height: tokens.spacing.lg),
                  Text(
                    "No repositories found",
                    style: tokens.text.headlineSmall,
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  Text(
                    "Try adjusting your search or filters",
                    style: tokens.text.bodyMedium?.copyWith(
                      color: tokens.color.onSurfaceWithOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  String _getSortOptionLabel(GitHubSortOption option) {
    switch (option) {
      case GitHubSortOption.updatedAt:
        return "Last Updated";
      case GitHubSortOption.stargazersCount:
        return "Most Stars";
      case GitHubSortOption.name:
        return "Name";
    }
  }

  void _openRoadmap(String url) {
    // This could navigate to a dedicated roadmap page or open the GitHub repo
    // For now, we'll just open the GitHub repo
    // You can implement custom roadmap viewing logic here
  }
}

/// Simple debouncer for search input
class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void call(VoidCallback callback) {
    _timer?.cancel();
    _timer = Timer(delay, callback);
  }

  void dispose() {
    _timer?.cancel();
  }
}
