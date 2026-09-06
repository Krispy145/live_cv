import "package:cv_app/data/showcase/auth_clients_case_study.dart";
import "package:cv_app/data/showcase/helping_hand_case_study.dart";
import "package:cv_app/data/showcase/kisbey_case_study.dart";
import "package:cv_app/data/showcase/secure_ai_case_study.dart";
import "package:cv_app/domain/showcase/showcase_models.dart";

/// In-repo catalog of featured case studies. No HTTP.
class ShowcaseCatalog {
  /// [ShowcaseCatalog] constructor.
  const ShowcaseCatalog();

  /// Featured studies in display order.
  static const List<CaseStudy> featured = [
    kisbeyCaseStudy,
    secureAiCaseStudy,
    helpingHandCaseStudy,
    authClientsCaseStudy,
  ];

  /// All studies (currently the featured set).
  static List<CaseStudy> get all => featured;

  /// Lookup by slug.
  static CaseStudy? bySlug(String slug) {
    for (final study in all) {
      if (study.slug == slug) {
        return study;
      }
    }
    return null;
  }

  /// Technologies grouped for the Engineering view.
  static List<(String, List<EngineeringTech>)> get stackGroups {
    const categories = <String, List<String>>{
      "Application": [
        "Flutter",
        "Dart",
        "React",
        "React Native",
        "TypeScript",
      ],
      "Backend": [
        "NestJS",
        "FastAPI",
        "GraphQL",
        "REST",
        "Prisma",
        "Python",
      ],
      "Cloud": [
        "AWS CDK",
        "Firebase",
      ],
      "Data": [
        "PostgreSQL",
        "Redis",
        "SQLite",
      ],
      "Infrastructure": [
        "Docker",
        "GitHub Actions",
        "JWT",
        "OAuth2",
      ],
    };

    return categories.entries.map((entry) {
      final techs = entry.value
          .map(
            (name) => EngineeringTech(
              name: name,
              category: entry.key,
              caseStudySlugs: all.where((study) => study.stack.contains(name)).map((study) => study.slug).toList(),
            ),
          )
          .where((tech) => tech.caseStudySlugs.isNotEmpty)
          .toList();
      return (entry.key, techs);
    }).toList();
  }
}
