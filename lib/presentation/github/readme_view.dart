import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/domain/repositories/github/readme_document.dart";
import "package:flutter/material.dart";
import "package:flutter_markdown_plus/flutter_markdown_plus.dart";
import "package:url_launcher/url_launcher.dart";

/// Renders a GitHub README with the Markdown widget.
class ReadmeView extends StatelessWidget {
  /// [ReadmeView] constructor.
  const ReadmeView({
    super.key,
    required this.document,
  });

  final ReadmeDocument document;

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final theme = Theme.of(context);
    return MarkdownBody(
      data: document.markdown,
      selectable: true,
      imageBuilder: (uri, title, alt) {
        final isBadge = uri.host.contains("shields.io");
        return Padding(
          padding: const EdgeInsets.only(right: 6, bottom: 4),
          child: Image.network(
            _networkImageUrl(uri),
            height: isBadge ? 20 : null,
            // CanvasKit cannot fetch shields.io / GitHub images unless the host
            // sends CORS headers. HTML <img> bypasses that restriction on web.
            webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
            errorBuilder: (context, error, stackTrace) => Text(alt ?? ""),
          ),
        );
      },
      onTapLink: (text, href, title) {
        if (href == null || href.isEmpty) {
          return;
        }
        final uri = Uri.tryParse(href);
        if (uri == null) {
          return;
        }
        launchUrl(uri, mode: LaunchMode.externalApplication);
      },
      styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
        p: tokens.text.bodyMedium,
        h1: tokens.text.headlineSmall?.copyWith(
          color: tokens.color.primary,
          fontWeight: FontWeight.w700,
        ),
        h2: tokens.text.titleLarge?.copyWith(
          color: tokens.color.primary,
          fontWeight: FontWeight.w600,
        ),
        h3: tokens.text.titleMedium?.copyWith(
          color: tokens.color.primary,
          fontWeight: FontWeight.w600,
        ),
        listBullet: tokens.text.bodyMedium,
        a: tokens.text.bodyMedium?.copyWith(
          color: tokens.color.primary,
          decoration: TextDecoration.underline,
        ),
        code: tokens.text.bodySmall?.copyWith(fontFamily: "monospace"),
        codeblockPadding: EdgeInsets.all(tokens.spacing.md),
        codeblockDecoration: BoxDecoration(
          color: tokens.color.surface,
          borderRadius: BorderRadius.circular(8),
        ),
        blockquote: tokens.text.bodyMedium?.copyWith(
          color: tokens.color.onSurface.withValues(alpha: 0.75),
        ),
      ),
    );
  }
}

String _networkImageUrl(Uri uri) {
  if (!uri.host.contains("shields.io")) {
    return uri.toString();
  }
  final path = uri.path.replaceAll(" ", "_");
  return uri.replace(path: path).toString();
}
