/// A GitHub README kept as raw markdown for preview dialogs.
class ReadmeDocument {
  /// [ReadmeDocument] constructor.
  const ReadmeDocument({
    required this.markdown,
  });

  /// Original README markdown.
  final String markdown;

  /// Wraps fetched markdown for the README preview.
  factory ReadmeDocument.parse(String markdown) {
    return ReadmeDocument(markdown: markdown.replaceAll("\r\n", "\n").trim());
  }
}
