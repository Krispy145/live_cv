import "package:cv_app/features/github/data/github_api.dart";
import "package:cv_app/features/github/data/github_repository.dart";
import "package:cv_app/features/github/domain/github_repo.dart";
import "package:cv_app/features/github/domain/roadmap_summary.dart";
import "package:cv_app/utils/loggers.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:utilities/logger/logger.dart";

/// Provider for GitHub API
final githubApiProvider = Provider<GitHubApi>((ref) {
  // Get GitHub token from environment or dart-define
  const githubToken = String.fromEnvironment("GITHUB_TOKEN");
  return GitHubApi(githubToken: githubToken.isEmpty ? null : githubToken);
});

/// Provider for SharedPreferences
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

/// Provider for GitHub Repository
final githubRepositoryProvider = FutureProvider<GitHubRepository>((ref) async {
  final api = ref.read(githubApiProvider);
  final prefs = await ref.read(sharedPreferencesProvider.future);
  final username = ref.read(githubUsernameProvider);
  return GitHubRepository(api: api, prefs: prefs, username: username);
});

/// Provider for GitHub username
final githubUsernameProvider = Provider<String>((ref) {
  const username = String.fromEnvironment("GITHUB_USERNAME");
  if (username.isEmpty) {
    // For development, you can set a default username here
    // or throw an error with more helpful instructions
    throw Exception("GITHUB_USERNAME must be set via --dart-define=GITHUB_USERNAME=your-username");
  }
  return username;
});

/// State for GitHub repositories
class GitHubState {
  final List<GitHubRepo> allRepos;
  final List<GitHubRepo> filteredRepos;
  final Set<String> allTopics;
  final Set<String> selectedTopics;
  final String searchQuery;
  final GitHubSortOption sortOption;
  final bool isLoading;
  final String? error;
  final bool isRateLimited;
  final RoadmapSummary? roadmapData;
  final bool isLoadingRoadmap;

  const GitHubState({
    this.allRepos = const [],
    this.filteredRepos = const [],
    this.allTopics = const {},
    this.selectedTopics = const {},
    this.searchQuery = "",
    this.sortOption = GitHubSortOption.updatedAt,
    this.isLoading = false,
    this.error,
    this.isRateLimited = false,
    this.roadmapData,
    this.isLoadingRoadmap = false,
  });

  GitHubState copyWith({
    List<GitHubRepo>? allRepos,
    List<GitHubRepo>? filteredRepos,
    Set<String>? allTopics,
    Set<String>? selectedTopics,
    String? searchQuery,
    GitHubSortOption? sortOption,
    bool? isLoading,
    String? error,
    bool? isRateLimited,
    RoadmapSummary? roadmapData,
    bool? isLoadingRoadmap,
  }) {
    return GitHubState(
      allRepos: allRepos ?? this.allRepos,
      filteredRepos: filteredRepos ?? this.filteredRepos,
      allTopics: allTopics ?? this.allTopics,
      selectedTopics: selectedTopics ?? this.selectedTopics,
      searchQuery: searchQuery ?? this.searchQuery,
      sortOption: sortOption ?? this.sortOption,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isRateLimited: isRateLimited ?? this.isRateLimited,
      roadmapData: roadmapData ?? this.roadmapData,
      isLoadingRoadmap: isLoadingRoadmap ?? this.isLoadingRoadmap,
    );
  }

  /// Get roadmap repository (if exists)
  GitHubRepo? get roadmapRepo {
    return allRepos.where((repo) => repo.isRoadmap).firstOrNull;
  }

  /// Get non-roadmap repositories
  List<GitHubRepo> get regularRepos {
    return filteredRepos.where((repo) => !repo.isRoadmap).toList();
  }
}

/// Sort options for GitHub repositories
enum GitHubSortOption {
  updatedAt,
  stargazersCount,
  name,
}

/// Notifier for GitHub repositories state
class GitHubNotifier extends StateNotifier<GitHubState> {
  GitHubNotifier(this._repository, this._username) : super(const GitHubState());

  GitHubNotifier._loading()
      : _repository = null,
        _username = "",
        super(const GitHubState(isLoading: true));

  GitHubNotifier._error(String error)
      : _repository = null,
        _username = "",
        super(GitHubState(error: error));

  final GitHubRepository? _repository;
  final String _username;

  /// Check if the notifier is properly initialized
  bool get isInitialized => _repository != null;

  /// Load repositories
  Future<void> loadRepositories() async {
    if (_repository == null) return;

    state = state.copyWith(isLoading: true);

    try {
      // First load basic repos for immediate display
      final basicRepos = await _repository!.getRepositories(_username);
      final topics = _extractAllTopics(basicRepos);

      state = state.copyWith(
        allRepos: basicRepos,
        allTopics: topics,
        isLoading: false,
      );

      _applyFilters();

      // Load roadmap data if roadmap repo exists
      final hasRoadmapRepo = basicRepos.any((repo) => repo.isRoadmap);
      AppLogger.print("GitHub State Debug:", [CVAppLoggers.github]);
      AppLogger.print("- Total repos loaded: ${basicRepos.length}", [CVAppLoggers.github]);
      AppLogger.print("- Has roadmap repo: $hasRoadmapRepo", [CVAppLoggers.github]);
      AppLogger.print("- Roadmap repo names: ${basicRepos.where((repo) => repo.isRoadmap).map((r) => r.name).toList()}", [CVAppLoggers.github]);

      if (hasRoadmapRepo) {
        AppLogger.print("Loading roadmap data...", [CVAppLoggers.github]);
        loadRoadmapData();
      } else {
        AppLogger.print("No roadmap repo found, skipping roadmap data load", [CVAppLoggers.github]);
      }

      // Enhance descriptions in background
      _enhanceDescriptionsInBackground();
    } on GitHubRateLimitException {
      state = state.copyWith(
        isLoading: false,
        isRateLimited: true,
        error: "Rate limit exceeded. Please set a Personal Access Token.",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Refresh repositories (force fetch from API)
  Future<void> refreshRepositories() async {
    if (_repository == null) return;

    state = state.copyWith(isLoading: true, isRateLimited: false);

    try {
      final repos = await _repository!.refreshRepositories(_username);
      final topics = _extractAllTopics(repos);

      state = state.copyWith(
        allRepos: repos,
        allTopics: topics,
        isLoading: false,
      );

      _applyFilters();
    } on GitHubRateLimitException {
      state = state.copyWith(
        isLoading: false,
        isRateLimited: true,
        error: "Rate limit exceeded. Please set a Personal Access Token.",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  /// Set search query
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Toggle topic selection
  void toggleTopic(String topic) {
    final newSelectedTopics = Set<String>.from(state.selectedTopics);
    if (newSelectedTopics.contains(topic)) {
      newSelectedTopics.remove(topic);
    } else {
      newSelectedTopics.add(topic);
    }

    state = state.copyWith(selectedTopics: newSelectedTopics);
    _applyFilters();
  }

  /// Clear all selected topics
  void clearSelectedTopics() {
    state = state.copyWith(selectedTopics: const {});
    _applyFilters();
  }

  /// Set sort option
  void setSortOption(GitHubSortOption sortOption) {
    state = state.copyWith(sortOption: sortOption);
    _applyFilters();
  }

  /// Apply filters and sorting
  void _applyFilters() {
    var filtered = List<GitHubRepo>.from(state.allRepos);

    // Apply search filter
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where(
            (repo) => repo.name.toLowerCase().contains(query),
          )
          .toList();
    }

    // Apply topic filter (AND logic - repo must contain all selected topics)
    if (state.selectedTopics.isNotEmpty) {
      filtered = filtered
          .where(
            (repo) => state.selectedTopics.every((topic) => repo.topics.contains(topic)),
          )
          .toList();
    }

    // Apply sorting
    switch (state.sortOption) {
      case GitHubSortOption.updatedAt:
        filtered.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case GitHubSortOption.stargazersCount:
        filtered.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
        break;
      case GitHubSortOption.name:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
    }

    state = state.copyWith(filteredRepos: filtered);
  }

  /// Extract all unique topics from repositories
  /// Load roadmap data
  Future<void> loadRoadmapData() async {
    if (_repository == null) {
      AppLogger.print("Roadmap loading failed: Repository is null", [CVAppLoggers.github]);
      return;
    }

    AppLogger.print("Starting roadmap data load for username: $_username", [CVAppLoggers.github]);
    state = state.copyWith(isLoadingRoadmap: true);

    try {
      final roadmapData = await _repository!.getRoadmapData(_username);
      AppLogger.print("Roadmap data loaded successfully: ${roadmapData != null}", [CVAppLoggers.github]);
      state = state.copyWith(
        roadmapData: roadmapData,
        isLoadingRoadmap: false,
      );
    } catch (e) {
      AppLogger.print("Roadmap loading error: $e", [CVAppLoggers.github]);
      state = state.copyWith(
        isLoadingRoadmap: false,
        // Don't set error for roadmap data failure, just log it
      );
    }
  }

  /// Enhance descriptions in background
  Future<void> _enhanceDescriptionsInBackground() async {
    if (_repository == null) return;

    try {
      final enhancedRepos = await _repository!.getRepositoriesWithEnhancedDescriptions(_username);
      final topics = _extractAllTopics(enhancedRepos);

      state = state.copyWith(
        allRepos: enhancedRepos,
        allTopics: topics,
      );

      _applyFilters();
    } catch (e) {
      // If enhancement fails, we still have the basic repos
      // Don't update state with error to avoid disrupting the UI
    }
  }

  Set<String> _extractAllTopics(List<GitHubRepo> repos) {
    final topics = <String>{};
    for (final repo in repos) {
      topics.addAll(repo.topics);
    }
    return topics;
  }
}

/// Provider for GitHub notifier
final githubNotifierProvider = StateNotifierProvider<GitHubNotifier, GitHubState>((ref) {
  final repositoryAsync = ref.watch(githubRepositoryProvider);
  final username = ref.watch(githubUsernameProvider);

  return repositoryAsync.when(
    data: (repository) => GitHubNotifier(repository, username),
    loading: GitHubNotifier._loading,
    error: (error, stack) => GitHubNotifier._error(error.toString()),
  );
});
