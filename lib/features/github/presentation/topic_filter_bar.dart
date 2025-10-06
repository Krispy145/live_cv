import "package:cv_app/features/github/state/github_state.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

/// Bar for filtering repositories by topics
class TopicFilterBar extends ConsumerWidget {
  const TopicFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(githubNotifierProvider);

    if (state.allTopics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Filter by topics:",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const Spacer(),
              if (state.selectedTopics.isNotEmpty)
                TextButton(
                  onPressed: () => ref.read(githubNotifierProvider.notifier).clearSelectedTopics(),
                  child: const Text("Clear all"),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // "All" chip
                FilterChip(
                  label: const Text("All"),
                  selected: state.selectedTopics.isEmpty,
                  onSelected: (selected) {
                    if (selected) {
                      ref.read(githubNotifierProvider.notifier).clearSelectedTopics();
                    }
                  },
                ),
                const SizedBox(width: 8),
                // Topic chips
                ...state.allTopics.map(
                  (topic) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(topic),
                      selected: state.selectedTopics.contains(topic),
                      onSelected: (selected) {
                        ref.read(githubNotifierProvider.notifier).toggleTopic(topic);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
