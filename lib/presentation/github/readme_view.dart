import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/repositories/github/readme_document.dart";
import "package:flutter/material.dart";

/// Renders a parsed README the way the original CV package did.
class ReadmeView extends StatelessWidget {
  /// [ReadmeView] constructor.
  const ReadmeView({
    super.key,
    required this.document,
    this.showTitle = true,
  });

  final ReadmeDocument document;
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final visible = document.sections.where((section) {
      final title = section.title.toLowerCase();
      return title.contains("status") || title.contains("highlight") || title.contains("architecture");
    }).toList();
    final sections = visible.isEmpty ? document.sections.take(3).toList() : visible;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle)
          Text(
            document.title,
            style: tokens.text.titleLarge?.copyWith(
              color: tokens.color.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        if (document.intro != null) ...[
          SizedBox(height: tokens.spacing.sm),
          Text(document.intro!, style: tokens.text.bodyMedium),
        ],
        ...sections.map((section) => _ReadmeSectionView(section: section, tokens: tokens)),
      ],
    );
  }
}

class _ReadmeSectionView extends StatelessWidget {
  const _ReadmeSectionView({required this.section, required this.tokens});

  final ReadmeSection section;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: tokens.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(color: tokens.color.outline.withValues(alpha: 0.2)),
          SizedBox(height: tokens.spacing.md),
          Row(
            children: [
              if (section.emoji != null) ...[
                Text(section.emoji!, style: const TextStyle(fontSize: 18)),
                SizedBox(width: tokens.spacing.sm),
              ],
              Text(
                section.title,
                style: tokens.text.titleMedium?.copyWith(
                  color: tokens.color.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: tokens.spacing.sm),
          ...section.blocks.map(
            (block) => switch (block) {
              ReadmeParagraph(:final text) => Padding(
                  padding: EdgeInsets.only(bottom: tokens.spacing.sm),
                  child: Text(text, style: tokens.text.bodyMedium),
                ),
              ReadmeBulletList(:final items) => Column(
                  children: items
                      .map(
                        (item) => Padding(
                          padding: EdgeInsets.only(bottom: tokens.spacing.xs),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("•  ", style: tokens.text.bodyMedium),
                              Expanded(
                                child: item.label == null
                                    ? Text(item.text, style: tokens.text.bodyMedium)
                                    : Text.rich(
                                        TextSpan(
                                          children: [
                                            TextSpan(
                                              text: item.label,
                                              style: tokens.text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                                            ),
                                            if (item.value != null)
                                              TextSpan(
                                                text: item.arrow ? " → ${item.value}" : ": ${item.value}",
                                                style: tokens.text.bodyMedium,
                                              ),
                                          ],
                                        ),
                                      ),
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ReadmeCode(:final code) => Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(top: tokens.spacing.sm, bottom: tokens.spacing.sm),
                  padding: EdgeInsets.all(tokens.spacing.md),
                  decoration: BoxDecoration(
                    color: tokens.color.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    code,
                    style: tokens.text.bodySmall?.copyWith(fontFamily: "monospace", height: 1.4),
                  ),
                ),
            },
          ),
        ],
      ),
    );
  }
}
