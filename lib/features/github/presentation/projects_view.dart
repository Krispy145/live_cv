import "package:auto_route/auto_route.dart";
import "package:cv_app/features/github/presentation/github_page.dart";
import "package:flutter/material.dart";

/// Wrapper view for GitHub projects page to work with auto_route
@RoutePage()
class ProjectsView extends StatelessWidget {
  const ProjectsView({super.key});

  @override
  Widget build(BuildContext context) {
    return const GitHubPage();
  }
}
