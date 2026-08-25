/// A GitHub README kept as raw markdown for preview dialogs.
class ReadmeDocument {
  /// [ReadmeDocument] constructor.
  const ReadmeDocument({
    required this.markdown,
  });

  /// Original README markdown.
  final String markdown;

  /// Wraps fetched markdown for the README preview.
  ///
  /// GitHub allows spaces in image URLs such as shields.io badges
  /// (`![Backend Projects](https://img.shields.io/badge/Backend Projects-100%25-green)`).
  /// CommonMark (used by this app) does not, so destinations are encoded first.
  factory ReadmeDocument.parse(String markdown) {
    final normalized = markdown.replaceAll("\r\n", "\n").trim();
    return ReadmeDocument(markdown: encodeLinkDestinations(normalized));
  }

  /// Percent-encodes whitespace in markdown image and link destinations.
  static String encodeLinkDestinations(String markdown) {
    return markdown.replaceAllMapped(
      _linkOrImagePattern,
      (match) {
        final prefix = match.group(1)!;
        final destination = match.group(2)!;
        final suffix = match.group(3)!;
        return "$prefix${_encodeDestination(destination)}$suffix";
      },
    );
  }

  static final _linkOrImagePattern = RegExp(r"(!?\[[^\]]*\]\()([^)]+)(\))");

  static String _encodeDestination(String raw) {
    var dest = raw.trim();
    var title = "";

    final titled = _titledDestination.firstMatch(dest);
    if (titled != null) {
      dest = titled.group(1) ?? titled.group(2)!;
      title = " ${titled.group(3)}";
    } else if (dest.startsWith("<") && dest.endsWith(">") && dest.length >= 2) {
      dest = dest.substring(1, dest.length - 1);
    }

    // shields.io treats `_` as a space in the badge label; `%20` also works on
    // GitHub but Flutter's image loader rejects URLs that still contain spaces.
    dest = dest.contains("shields.io")
        ? dest.replaceAll(RegExp(r"\s+"), "_")
        : dest.replaceAll(RegExp(r"\s+"), "%20");
    return "$dest$title";
  }

  static final _titledDestination = RegExp(
    r"""^(?:<([^>]*)>|(\S+))\s+([("'`].+)$""",
  );
}
