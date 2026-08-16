import "package:cv_app/data/models/github_repo_model.dart";
import "package:cv_app/domain/repositories/github/github.repository.dart";
import "package:cv_app/domain/repositories/github/roadmap_summary.dart";
import "package:cv_app/utils/loggers.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:utilities/logger/logger.dart";

/// Immutable GitHub UI state.
class GitHubState {
  /// [GitHubState] constructor.
  const GitHubState({
    this.allRepos = const [],
    this.isLoading = false,
    this.isLoadingRoadmap = false,
    this.error,
    this.roadmapData,
  });

  final List<GitHubRepoModel> allRepos;
  final bool isLoading;
  final bool isLoadingRoadmap;
  final String? error;
  final RoadmapSummary? roadmapData;

  /// Repositories excluding the dedicated roadmap repo.
  List<GitHubRepoModel> get regularRepos => allRepos.where((repo) => !repo.isRoadmap).toList();

  GitHubState copyWith({
    List<GitHubRepoModel>? allRepos,
    bool? isLoading,
    bool? isLoadingRoadmap,
    String? error,
    RoadmapSummary? roadmapData,
    bool clearError = false,
  }) {
    return GitHubState(
      allRepos: allRepos ?? this.allRepos,
      isLoading: isLoading ?? this.isLoading,
      isLoadingRoadmap: isLoadingRoadmap ?? this.isLoadingRoadmap,
      error: clearError ? null : error ?? this.error,
      roadmapData: roadmapData ?? this.roadmapData,
    );
  }
}

/// Riverpod notifier that loads GitHub repositories and roadmap data.
class GitHubNotifier extends Notifier<GitHubState> {
  GitHubRepository get _repository => ref.read(githubRepositoryProvider);

  /// Whether [build] has completed.
  bool isInitialized = false;

  @override
  GitHubState build() {
    isInitialized = true;
    return const GitHubState();
  }

  /// Loads repositories and the roadmap manifest.
  Future<void> loadRepositories({bool forceRefresh = false}) async {
    state = state.copyWith(isLoading: true, isLoadingRoadmap: true, clearError: true);
    AppLogger.print("Loading GitHub repositories", [CVAppLoggers.github]);
    try {
      final repos = await _repository.getRepositories(forceRefresh: forceRefresh);
      state = state.copyWith(allRepos: repos, isLoading: false);
      final roadmap = await _repository.getRoadmapSummary(forceRefresh: forceRefresh);
      state = state.copyWith(roadmapData: roadmap, isLoadingRoadmap: false);
      AppLogger.print("Loaded ${repos.length} GitHub repositories", [CVAppLoggers.github], type: LoggerType.confirmation);
    } catch (error) {
      AppLogger.print("GitHub load failed: $error", [CVAppLoggers.github], type: LoggerType.error);
      state = state.copyWith(
        isLoading: false,
        isLoadingRoadmap: false,
        error: error.toString(),
      );
    }
  }
}

/// GitHub username from `--dart-define`.
final githubUsernameProvider = Provider<String>(
  (ref) => const String.fromEnvironment("GITHUB_USERNAME", defaultValue: "Krispy145"),
);

final githubRepositoryProvider = Provider<GitHubRepository>(
  (ref) => GitHubRepository(username: ref.watch(githubUsernameProvider)),
);

final githubNotifierProvider = NotifierProvider<GitHubNotifier, GitHubState>(GitHubNotifier.new);
