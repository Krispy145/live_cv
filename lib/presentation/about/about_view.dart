import "package:auto_route/auto_route.dart";
import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/timeline_model.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/presentation/components/experience_card.dart";
import "package:cv_app/presentation/components/timeline_editor_dialog.dart";
import "package:cv_app/presentation/github/github_loader.dart";
import "package:cv_app/presentation/github/github_state.dart";
import "package:cv_app/presentation/github/roadmap_card.dart";
import "package:cv_app/presentation/work/components/showcase_page.dart";
import "package:flutter/material.dart";
import "package:flutter_mobx/flutter_mobx.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:utilities/data/sources/source.dart";

/// Experience, education, and condensed roadmap.
@RoutePage()
class AboutView extends ConsumerStatefulWidget {
  /// [AboutView] constructor.
  const AboutView({super.key});

  @override
  ConsumerState<AboutView> createState() => _AboutViewState();
}

class _AboutViewState extends ConsumerState<AboutView> {
  late final _store = Managers.appWrapperStore;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ensureGitHubLoaded(ref);
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
    final response = isEducation ? await _store.upsertEducation(entry) : await _store.upsertExperience(entry);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          response == RequestResponse.success ? (isEducation ? "Education saved." : "Experience saved.") : "Could not save to Firestore.",
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
        content: Text('Remove "$title" from this CV?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
          FilledButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("Delete")),
        ],
      ),
    );
    if (confirmed != true || !mounted) {
      return;
    }
    final response = await _store.removeTimeline(id: id, isEducation: isEducation);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response == RequestResponse.success ? "Removed." : "Could not update Firestore.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final canEdit = Managers.config.showDevTools;
    final githubState = ref.watch(githubNotifierProvider);

    return SingleChildScrollView(
      child: ShowcasePage(
        child: Observer(
          builder: (context) {
            final experience = _store.userDetails?.experience ?? const <TimelineModel>[];
            final education = _store.userDetails?.education ?? const <TimelineModel>[];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("About", style: tokens.text.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                SizedBox(height: tokens.spacing.sm),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 640),
                  child: Text(
                    _store.userDetails?.summary ?? "I build production-grade applications from Flutter interfaces through to cloud infrastructure.",
                    style: tokens.text.bodyLarge?.copyWith(height: 1.5, color: tokens.color.onSurfaceWithOpacity(0.75)),
                  ),
                ),
                SizedBox(height: tokens.spacing.xxl),
                _SectionHeading(
                  title: "Experience",
                  action: canEdit
                      ? TextButton.icon(
                          onPressed: () => _editTimeline(isEducation: false),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text("Add"),
                        )
                      : null,
                  tokens: tokens,
                ),
                ...experience.asMap().entries.map(
                      (entry) => ExperienceCard(
                        timelineModel: entry.value,
                        index: entry.key,
                        isLast: entry.key == experience.length - 1,
                        onEdit: canEdit ? () => _editTimeline(isEducation: false, initial: entry.value) : null,
                        onDelete: canEdit ? () => _deleteTimeline(id: entry.value.id, isEducation: false, title: entry.value.title) : null,
                      ),
                    ),
                SizedBox(height: tokens.spacing.xxl),
                _SectionHeading(
                  title: "Education",
                  action: canEdit
                      ? TextButton.icon(
                          onPressed: () => _editTimeline(isEducation: true),
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text("Add"),
                        )
                      : null,
                  tokens: tokens,
                ),
                ...education.asMap().entries.map(
                      (entry) => EducationCard(
                        timelineModel: entry.value,
                        index: entry.key,
                        isLast: entry.key == education.length - 1,
                        onEdit: canEdit ? () => _editTimeline(isEducation: true, initial: entry.value) : null,
                        onDelete: canEdit ? () => _deleteTimeline(id: entry.value.id, isEducation: true, title: entry.value.title) : null,
                      ),
                    ),
                SizedBox(height: tokens.spacing.xxl),
                _SectionHeading(title: "Roadmap", tokens: tokens),
                if (githubState.roadmapData != null)
                  RoadmapCard(
                    data: githubState.roadmapData!,
                    username: ref.watch(githubUsernameProvider),
                  )
                else if (githubState.isLoadingRoadmap)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  Text(
                    "Roadmap data is loaded from GitHub when available.",
                    style: tokens.text.bodyMedium?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6)),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({required this.title, required this.tokens, this.action});

  final String title;
  final ThemeTokens tokens;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: tokens.spacing.lg),
      child: Row(
        children: [
          Text(title, style: tokens.text.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
          const Spacer(),
          if (action != null) action!,
        ],
      ),
    );
  }
}
