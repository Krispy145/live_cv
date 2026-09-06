import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";
import "package:cv_app/presentation/work/components/openapi_list.dart";
import "package:flutter/material.dart";

/// Deterministic request/response playground. No live HTTP.
class ApiPlayground extends StatefulWidget {
  /// [ApiPlayground] constructor.
  const ApiPlayground({super.key, required this.endpoints});

  final List<ShowcaseEndpoint> endpoints;

  @override
  State<ApiPlayground> createState() => _ApiPlaygroundState();
}

class _ApiPlaygroundState extends State<ApiPlayground> {
  late ShowcaseEndpoint _selected;
  bool _sending = false;
  bool _hasResponse = false;
  int _sendGeneration = 0;

  @override
  void initState() {
    super.initState();
    _selected = widget.endpoints.first;
  }

  Future<void> _send() async {
    final generation = ++_sendGeneration;
    final endpoint = _selected;
    setState(() {
      _sending = true;
      _hasResponse = false;
    });
    await Future<void>.delayed(Duration(milliseconds: endpoint.responseMs));
    if (!mounted || generation != _sendGeneration) {
      return;
    }
    setState(() {
      _sending = false;
      _hasResponse = true;
    });
  }

  void _select(ShowcaseEndpoint endpoint) {
    _sendGeneration++;
    setState(() {
      _selected = endpoint;
      _hasResponse = false;
      _sending = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final wide = constraints.maxWidth > 800;
        final docs = OpenApiList(
          endpoints: widget.endpoints,
          selectedId: _selected.id,
          onSelect: _select,
        );
        final console = _Console(
          endpoint: _selected,
          sending: _sending,
          hasResponse: _hasResponse,
          onSend: _sending ? null : _send,
          tokens: tokens,
        );
        if (wide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: docs),
              SizedBox(width: tokens.spacing.xl),
              Expanded(flex: 3, child: console),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            docs,
            SizedBox(height: tokens.spacing.xl),
            console,
          ],
        );
      },
    );
  }
}

class _Console extends StatelessWidget {
  const _Console({
    required this.endpoint,
    required this.sending,
    required this.hasResponse,
    required this.tokens,
    this.onSend,
  });

  final ShowcaseEndpoint endpoint;
  final bool sending;
  final bool hasResponse;
  final VoidCallback? onSend;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${endpoint.method}  ${endpoint.path}",
          style: tokens.text.titleMedium?.copyWith(fontWeight: FontWeight.w700, fontFamily: "monospace"),
        ),
        SizedBox(height: tokens.spacing.xs),
        Text(endpoint.summary, style: tokens.text.bodyMedium?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.7))),
        if (endpoint.note != null) ...[
          SizedBox(height: tokens.spacing.sm),
          Text(endpoint.note!, style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.6))),
        ],
        SizedBox(height: tokens.spacing.lg),
        Text("REQUEST", style: tokens.text.bodySmall?.copyWith(letterSpacing: 1, fontWeight: FontWeight.w700)),
        SizedBox(height: tokens.spacing.sm),
        _CodeBlock(text: endpoint.requestJson, tokens: tokens),
        SizedBox(height: tokens.spacing.md),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton(
            onPressed: onSend,
            child: sending
                ? SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: tokens.color.onPrimary),
                  )
                : const Text("Send Request"),
          ),
        ),
        if (hasResponse) ...[
          SizedBox(height: tokens.spacing.lg),
          Row(
            children: [
              Text(endpoint.statusLabel, style: tokens.text.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              Text("${endpoint.responseMs}ms", style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.55))),
            ],
          ),
          SizedBox(height: tokens.spacing.sm),
          _CodeBlock(text: endpoint.responseJson, tokens: tokens),
          SizedBox(height: tokens.spacing.sm),
          Text(
            "Simulated response. This site does not call a hosted backend.",
            style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.5)),
          ),
        ],
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.text, required this.tokens});

  final String text;
  final ThemeTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(tokens.spacing.md),
      decoration: BoxDecoration(
        color: tokens.color.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(4),
      ),
      child: SelectableText(
        text.trim(),
        style: tokens.text.bodySmall?.copyWith(fontFamily: "monospace", height: 1.45),
      ),
    );
  }
}
