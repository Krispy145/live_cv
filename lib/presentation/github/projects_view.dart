import "package:auto_route/auto_route.dart";
import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/github_repo_model.dart";
import "package:cv_app/presentation/github/github_repo_card.dart";
import "package:cv_app/presentation/github/github_state.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

enum _ProjectSort { updated, stars, name }

/// Full-page GitHub projects browser.
@RoutePage()
class ProjectsView extends ConsumerStatefulWidget {
  /// [ProjectsView] constructor.
  const ProjectsView({super.key});

  @override
  ConsumerState<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  String _query = "";
  final Set<String> _selectedTopics = {};
  _ProjectSort _sort = _ProjectSort.updated;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(githubNotifierProvider.notifier);
      final state = ref.read(githubNotifierProvider);
      if (notifier.isInitialized && state.allRepos.isEmpty && !state.isLoading) {
        notifier.loadRepositories();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final githubState = ref.watch(githubNotifierProvider);
    final username = ref.watch(githubUsernameProvider);
    final repos = _filtered(githubState.regularRepos);
    final topics = githubState.regularRepos.expand((repo) => repo.topics).where((topic) => topic.toLowerCase() != GitHubRepoModel.hiddenFromCvTopic).toSet().toList()
      ..sort();

    return Scaffold(
      appBar: AppBar(
        title: const Text("GitHub Projects"),
      ),
      body: Padding(
        padding: EdgeInsets.all(tokens.spacing.lg),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search repositories",
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
            SizedBox(height: tokens.spacing.md),
            Row(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: topics
                          .map(
                            (topic) => Padding(
                              padding: EdgeInsets.only(right: tokens.spacing.xs),
                              child: FilterChip(
                                label: Text(topic),
                                selected: _selectedTopics.contains(topic),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _selectedTopics.add(topic);
                                    } else {
                                      _selectedTopics.remove(topic);
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                PopupMenuButton<_ProjectSort>(
                  initialValue: _sort,
                  onSelected: (value) => setState(() => _sort = value),
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: _ProjectSort.updated, child: Text("Last updated")),
                    PopupMenuItem(value: _ProjectSort.stars, child: Text("Stars")),
                    PopupMenuItem(value: _ProjectSort.name, child: Text("Name")),
                  ],
                  icon: const Icon(Icons.sort),
                ),
              ],
            ),
            SizedBox(height: tokens.spacing.lg),
            Expanded(
              child: githubState.isLoading && githubState.allRepos.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 360,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: repos.length,
                      itemBuilder: (context, index) => GitHubRepoCard(
                        repo: repos[index],
                        username: username,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  List<GitHubRepoModel> _filtered(List<GitHubRepoModel> repos) {
    var result = repos;
    if (_query.isNotEmpty) {
      final query = _query.toLowerCase();
      result = result.where((repo) => repo.name.toLowerCase().contains(query) || (repo.description?.toLowerCase().contains(query) ?? false)).toList();
    }
    if (_selectedTopics.isNotEmpty) {
      result = result.where((repo) => repo.topics.any(_selectedTopics.contains)).toList();
    }
    switch (_sort) {
      case _ProjectSort.updated:
        result.sort((a, b) => (b.lastActivity ?? DateTime(0)).compareTo(a.lastActivity ?? DateTime(0)));
      case _ProjectSort.stars:
        result.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
      case _ProjectSort.name:
        result.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    return result;
  }
}
