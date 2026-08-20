/// A structured README matching the generated roadmap / project docs.
class ReadmeDocument {
  /// [ReadmeDocument] constructor.
  const ReadmeDocument({
    required this.title,
    this.intro,
    this.sections = const [],
  });

  final String title;
  final String? intro;
  final List<ReadmeSection> sections;

  factory ReadmeDocument.parse(String markdown) {
    final lines = markdown.replaceAll("\r\n", "\n").split("\n");
    var title = "";
    final introLines = <String>[];
    final sections = <ReadmeSection>[];
    String? currentHeading;
    String? currentEmoji;
    final body = <String>[];

    void flushSection() {
      if (currentHeading == null) {
        return;
      }
      sections.add(ReadmeSection.parse(heading: currentHeading, emoji: currentEmoji, rawLines: List<String>.from(body)));
      body.clear();
    }

    var seenTitle = false;
    for (final rawLine in lines) {
      final line = rawLine.trimRight();
      if (!seenTitle && line.startsWith("# ")) {
        title = line.substring(2).trim();
        seenTitle = true;
        continue;
      }
      if (line.startsWith("## ")) {
        flushSection();
        seenTitle = true;
        final heading = line.substring(3).trim();
        currentEmoji = _leadingEmoji(heading);
        currentHeading = currentEmoji == null ? heading : heading.substring(currentEmoji.length).trim();
        continue;
      }
      if (currentHeading == null) {
        if (line.trim() == "---") {
          continue;
        }
        introLines.add(line);
      } else {
        body.add(line);
      }
    }
    flushSection();

    final intro = introLines.join("\n").trim();
    return ReadmeDocument(
      title: title.isEmpty ? "README" : title,
      intro: intro.isEmpty ? null : intro,
      sections: sections,
    );
  }
}

/// One `##` section of a README.
class ReadmeSection {
  /// [ReadmeSection] constructor.
  const ReadmeSection({
    required this.title,
    this.emoji,
    this.blocks = const [],
  });

  final String title;
  final String? emoji;
  final List<ReadmeBlock> blocks;

  factory ReadmeSection.parse({
    required String heading,
    required List<String> rawLines,
    String? emoji,
  }) {
    final blocks = <ReadmeBlock>[];
    final paragraph = <String>[];
    final bullets = <ReadmeBullet>[];
    var inCode = false;
    final code = <String>[];

    void flushParagraph() {
      final text = paragraph.join(" ").trim();
      paragraph.clear();
      if (text.isNotEmpty) {
        blocks.add(ReadmeParagraph(text));
      }
    }

    void flushBullets() {
      if (bullets.isEmpty) {
        return;
      }
      blocks.add(ReadmeBulletList(List<ReadmeBullet>.from(bullets)));
      bullets.clear();
    }

    for (final line in rawLines) {
      final trimmed = line.trim();
      if (trimmed.startsWith("```")) {
        flushParagraph();
        flushBullets();
        if (inCode) {
          blocks.add(ReadmeCode(code.join("\n")));
          code.clear();
          inCode = false;
        } else {
          inCode = true;
        }
        continue;
      }
      if (inCode) {
        code.add(line);
        continue;
      }
      if (trimmed == "---" || trimmed.isEmpty) {
        flushParagraph();
        flushBullets();
        continue;
      }
      if (trimmed.startsWith("- ") || trimmed.startsWith("* ")) {
        flushParagraph();
        bullets.add(ReadmeBullet.parse(trimmed.substring(2).trim()));
        continue;
      }
      flushBullets();
      paragraph.add(trimmed);
    }
    if (inCode) {
      blocks.add(ReadmeCode(code.join("\n")));
    }
    flushParagraph();
    flushBullets();

    return ReadmeSection(title: heading, emoji: emoji, blocks: blocks);
  }
}

/// A content block inside a [ReadmeSection].
sealed class ReadmeBlock {
  const ReadmeBlock();
}

/// Paragraph text.
class ReadmeParagraph extends ReadmeBlock {
  /// [ReadmeParagraph] constructor.
  const ReadmeParagraph(this.text);
  final String text;
}

/// Fenced code.
class ReadmeCode extends ReadmeBlock {
  /// [ReadmeCode] constructor.
  const ReadmeCode(this.code);
  final String code;
}

/// Bullet list.
class ReadmeBulletList extends ReadmeBlock {
  /// [ReadmeBulletList] constructor.
  const ReadmeBulletList(this.items);
  final List<ReadmeBullet> items;
}

/// A single bullet, optionally split into label / value.
class ReadmeBullet {
  /// [ReadmeBullet] constructor.
  const ReadmeBullet({
    required this.text,
    this.label,
    this.value,
    this.arrow = false,
  });

  final String text;
  final String? label;
  final String? value;
  final bool arrow;

  factory ReadmeBullet.parse(String raw) {
    final arrowMatch = RegExp(r"^\*\*(.+?)\*\*\s*→\s*(.*)$").firstMatch(raw);
    if (arrowMatch != null) {
      return ReadmeBullet(text: raw, label: arrowMatch.group(1)!.trim(), value: arrowMatch.group(2)!.trim(), arrow: true);
    }
    final colon = RegExp(r"^\*\*(.+?):\*\*\s*(.*)$").firstMatch(raw);
    if (colon != null) {
      return ReadmeBullet(text: raw, label: colon.group(1)!.trim(), value: colon.group(2)!.trim());
    }
    final labeled = RegExp(r"^\*\*(.+?)\*\*\s*(.*)$").firstMatch(raw);
    if (labeled != null) {
      final rest = labeled.group(2)!.trim();
      return ReadmeBullet(text: raw, label: labeled.group(1)!.trim(), value: rest.isEmpty ? null : rest);
    }
    return ReadmeBullet(text: raw);
  }
}

String? _leadingEmoji(String text) {
  if (text.isEmpty) {
    return null;
  }
  final runes = text.runes.toList();
  if (runes.first < 0x2000) {
    return null;
  }
  var count = 1;
  if (runes.length > 1 && runes[1] == 0xFE0F) {
    count = 2;
  }
  return String.fromCharCodes(runes.take(count));
}
