import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:flutter/material.dart";

/// Layered architecture diagram built from [ArchitectureGraph].
class ArchitectureDiagram extends StatelessWidget {
  /// [ArchitectureDiagram] constructor.
  const ArchitectureDiagram({super.key, required this.graph});

  final ArchitectureGraph graph;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < graph.layers.length; i++) ...[
          _LayerRow(nodes: graph.layers[i], tokens: tokens),
          if (i < graph.layers.length - 1)
            Padding(
              padding: EdgeInsets.symmetric(vertical: tokens.spacing.sm),
              child: Icon(Icons.south, size: 16, color: tokens.color.onSurfaceWithOpacity(0.35)),
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

class _LayerRow extends StatelessWidget {
  const _LayerRow({required this.nodes, required this.tokens});

  final List<String> nodes;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: tokens.spacing.sm,
      runSpacing: tokens.spacing.sm,
      children: nodes
          .map(
            (node) => Container(
              padding: EdgeInsets.symmetric(horizontal: tokens.spacing.md, vertical: tokens.spacing.sm),
              decoration: BoxDecoration(
                border: Border.all(color: tokens.color.outline.withValues(alpha: 0.35)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                node,
                style: tokens.text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
          )
          .toList(),
    );
  }
}
