import "package:cv_app/presentation/github/github_state.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Loads GitHub repos/roadmap when either payload is still missing.
void ensureGitHubLoaded(WidgetRef ref) {
  final notifier = ref.read(githubNotifierProvider.notifier);
  final state = ref.read(githubNotifierProvider);
  if (!notifier.isInitialized || state.isLoading || state.isLoadingRoadmap) {
    return;
  }
  if (state.allRepos.isEmpty || state.roadmapData == null) {
    notifier.loadRepositories();
  }
}
