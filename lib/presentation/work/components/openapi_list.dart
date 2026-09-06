import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:flutter/material.dart";

/// Static OpenAPI-style operation list (not an embedded Swagger iframe).
class OpenApiList extends StatelessWidget {
  /// [OpenApiList] constructor.
  const OpenApiList({
    super.key,
    required this.endpoints,
    this.onSelect,
    this.selectedId,
  });

  final List<ShowcaseEndpoint> endpoints;
  final ValueChanged<ShowcaseEndpoint>? onSelect;
  final String? selectedId;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final groups = <String, List<ShowcaseEndpoint>>{};
    for (final endpoint in endpoints) {
      groups.putIfAbsent(endpoint.group, () => []).add(endpoint);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groups.entries.map((entry) {
        return Padding(
          padding: EdgeInsets.only(bottom: tokens.spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(entry.key, style: tokens.text.titleSmall?.copyWith(fontWeight: FontWeight.w700, letterSpacing: 0.6)),
              SizedBox(height: tokens.spacing.sm),
              ...entry.value.map(
                (endpoint) => _OperationRow(
                  endpoint: endpoint,
                  selected: endpoint.id == selectedId,
                  onTap: onSelect == null ? null : () => onSelect!(endpoint),
                  tokens: tokens,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _OperationRow extends StatelessWidget {
  const _OperationRow({
    required this.endpoint,
    required this.selected,
    required this.tokens,
    this.onTap,
  });

  final ShowcaseEndpoint endpoint;
  final bool selected;
  final VoidCallback? onTap;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    final methodColor = switch (endpoint.method) {
      "GET" => const Color(0xFF2E7D32),
      "POST" => const Color(0xFF1565C0),
      "QUERY" => const Color(0xFF6A1B9A),
      _ => tokens.color.primary,
    };

    return Material(
      color: selected ? tokens.color.primary.withValues(alpha: 0.06) : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: tokens.spacing.sm),
          child: Row(
            children: [
              SizedBox(
                width: 64,
                child: Text(
                  endpoint.method,
                  style: tokens.text.labelStyle(methodColor),
                ),
              ),
              Expanded(
                child: Text(endpoint.path, style: tokens.text.bodyMedium?.copyWith(fontFamily: "monospace")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on ThemeTextTokens {
  TextStyle labelStyle(Color color) =>
      (bodySmall ?? const TextStyle(fontSize: 12)).copyWith(fontWeight: FontWeight.w700, color: color, letterSpacing: 0.4);
}
