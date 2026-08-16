import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:flutter/foundation.dart";
import "package:flutter/material.dart";
import "package:universal_html/html.dart" as html;

/// Dialog that previews and downloads the generated resume PDF.
class ResumePreviewDialog extends StatelessWidget {
  /// [ResumePreviewDialog] constructor.
  const ResumePreviewDialog({
    super.key,
    required this.header,
    this.cachedPdfBytes,
  });

  final HeaderModel header;
  final Uint8List? cachedPdfBytes;

  /// Shows the resume preview dialog.
  static Future<void> show(
    BuildContext context, {
    required HeaderModel header,
    Uint8List? cachedPdfBytes,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => ResumePreviewDialog(
        header: header,
        cachedPdfBytes: cachedPdfBytes,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final appStore = Managers.appWrapperStore;

    return AlertDialog(
      title: const Text("Download resume"),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Generate a PDF resume for ${header.userDetails.fullName}.",
              style: tokens.text.bodyMedium,
            ),
            SizedBox(height: tokens.spacing.md),
            if (appStore.isPdfGenerating)
              const LinearProgressIndicator()
            else if (appStore.pdfError != null)
              Text(appStore.pdfError!, style: tokens.text.bodySmall?.copyWith(color: tokens.color.error))
            else
              Text(
                cachedPdfBytes != null || appStore.cachedPdfBytes != null ? "Your resume is ready to download." : "The resume will be generated now.",
                style: tokens.text.bodySmall?.copyWith(color: tokens.color.onSurfaceWithOpacity(0.7)),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Close"),
        ),
        FilledButton.icon(
          onPressed: () => _download(context),
          icon: const Icon(Icons.download),
          label: const Text("Download PDF"),
        ),
      ],
    );
  }

  Future<void> _download(BuildContext context) async {
    final bytes = cachedPdfBytes ?? await Managers.appWrapperStore.getCachedPdf();
    if (bytes == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Unable to generate the resume right now.")),
        );
      }
      return;
    }

    final filename = "${header.userDetails.fullName.replaceAll(" ", "_")}_Resume.pdf";
    if (kIsWeb) {
      final blob = html.Blob([bytes], "application/pdf");
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", filename)
        ..click();
      html.Url.revokeObjectUrl(url);
    }
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
