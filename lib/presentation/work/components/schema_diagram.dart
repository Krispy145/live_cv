import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:flutter/material.dart";

/// Compact ERD excerpt.
class SchemaDiagram extends StatelessWidget {
  /// [SchemaDiagram] constructor.
  const SchemaDiagram({super.key, required this.graph});

  final SchemaGraph graph;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: tokens.spacing.md,
          runSpacing: tokens.spacing.md,
          children: graph.entities.map((entity) => _EntityCard(entity: entity, tokens: tokens)).toList(),
        ),
        if (graph.relations.isNotEmpty) ...[
          SizedBox(height: tokens.spacing.lg),
          Text("Relations", style: tokens.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          SizedBox(height: tokens.spacing.sm),
          ...graph.relations.map(
            (relation) => Padding(
              padding: EdgeInsets.only(bottom: tokens.spacing.xs),
              child: Text(
                "${relation.from}  →  ${relation.to}${relation.label.isEmpty ? "" : "  (${relation.label})"}",
                style: tokens.text.bodyMedium?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.75)),
              ),
            ),
          ),
        ],
        if (graph.caption != null) ...[
          SizedBox(height: tokens.spacing.md),
          Text(
            graph.caption!,
            style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6)),
          ),
        ],
      ],
    );
  }
}

class _EntityCard extends StatelessWidget {
  const _EntityCard({required this.entity, required this.tokens});

  final SchemaEntity entity;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      decoration: BoxDecoration(
        border: Border.all(color: tokens.color.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md, vertical: tokens.spacing.sm),
            color: tokens.color.surfaceContainerHighest,
            child: Text(entity.name, style: tokens.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
          ),
          Padding(
            padding: EdgeInsets.all(tokens.spacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: entity.fields
                  .map(
                    (field) => Padding(
                      padding: EdgeInsets.only(bottom: tokens.spacing.xs),
                      child: Text(field, style: tokens.text.bodySmall),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
