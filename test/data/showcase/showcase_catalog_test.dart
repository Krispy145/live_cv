import "package:cv_app/data/showcase/showcase_catalog.dart";
import "package:flutter_test/flutter_test.dart";

void main() {
  test("featured catalog has four unique slugs", () {
    final slugs = ShowcaseCatalog.featured.map((study) => study.slug).toList();
    expect(slugs, ["kisbey-pos", "secure-ai-api", "helping-hand", "auth-clients"]);
    expect(slugs.toSet().length, slugs.length);
  });

  test("each featured study has a simulated API playground", () {
    for (final study in ShowcaseCatalog.featured) {
      expect(study.endpoints, isNotEmpty, reason: study.slug);
      expect(study.architecture.layers, isNotEmpty, reason: study.slug);
      expect(study.schema.entities, isNotEmpty, reason: study.slug);
    }
  });

  test("engineering stack links technologies back to case studies", () {
    final flutter = ShowcaseCatalog.stackGroups.expand((group) => group.$2).firstWhere((tech) => tech.name == "Flutter");
    expect(flutter.caseStudySlugs, containsAll(["kisbey-pos", "helping-hand", "auth-clients"]));
  });
}
