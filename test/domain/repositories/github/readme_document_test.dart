import "package:cv_app/domain/repositories/github/readme_document.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("encodes spaces in GitHub shields.io badge URLs so CommonMark can parse them", () {
    const source = """
# AI + Cybersecurity Roadmap

![Learning](https://img.shields.io/badge/Learning-33%25-yellow) ![Backend Projects](https://img.shields.io/badge/Backend Projects-100%25-brightgreen) ![Flutter Projects](https://img.shields.io/badge/Flutter Projects-67%25-green)

_Last updated: 23/08/2026_
""";

    final document = ReadmeDocument.parse(source);

    expect(
      document.markdown,
      contains("![Backend Projects](https://img.shields.io/badge/Backend_Projects-100%25-brightgreen)"),
    );
    expect(
      document.markdown,
      contains("![Flutter Projects](https://img.shields.io/badge/Flutter_Projects-67%25-green)"),
    );
    expect(document.markdown, contains("![Learning](https://img.shields.io/badge/Learning-33%25-yellow)"));
    expect(document.markdown, contains("_Last updated: 23/08/2026_"));
  });

  test("keeps quoted link titles and does not double-encode percent sequences", () {
    const source = '[Docs](https://example.com/path%20already "API docs")';

    expect(
      ReadmeDocument.encodeLinkDestinations(source),
      '[Docs](https://example.com/path%20already "API docs")',
    );
  });
}
