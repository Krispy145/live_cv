/// Curated engineering case study shown on the portfolio.
class CaseStudy {
  /// [CaseStudy] constructor.
  const CaseStudy({
    required this.slug,
    required this.title,
    required this.subtitle,
    required this.year,
    required this.role,
    required this.platform,
    required this.stack,
    required this.problem,
    required this.solution,
    required this.product,
    required this.result,
    required this.decisions,
    required this.endpoints,
    required this.schema,
    required this.architecture,
    required this.infrastructure,
    this.featured = true,
    this.sourceVisibility = SourceVisibility.public,
    this.githubUrl,
    this.relatedRepos = const [],
    this.index = 1,
  });

  /// URL slug, e.g. `kisbey-pos`.
  final String slug;

  /// Display title.
  final String title;

  /// One-line positioning.
  final String subtitle;

  /// Year shown in the case-study header.
  final String year;

  /// Role on the project.
  final String role;

  /// Platforms, e.g. `Desktop / Mobile / Cloud`.
  final String platform;

  /// Technologies used — also powers the Engineering view.
  final List<String> stack;

  /// Whether this study appears in Selected Work.
  final bool featured;

  /// Whether source can be linked publicly.
  final SourceVisibility sourceVisibility;

  /// Public GitHub URL when [sourceVisibility] is public.
  final String? githubUrl;

  /// Related repositories shown as links.
  final List<RelatedRepo> relatedRepos;

  /// Featured-work ordinal (01, 02, …).
  final int index;

  final String problem;
  final String solution;
  final String product;
  final String result;
  final List<EngineeringDecision> decisions;
  final List<ShowcaseEndpoint> endpoints;
  final SchemaGraph schema;
  final ArchitectureGraph architecture;
  final List<InfraNote> infrastructure;

  /// Stack joined for compact display.
  String get stackLabel => stack.join("     ");
}

/// Whether a case study can link to source.
enum SourceVisibility {
  /// Public GitHub repository.
  public,

  /// Private product; walkthrough on request.
  private,
}

/// A repository associated with a case study.
class RelatedRepo {
  /// [RelatedRepo] constructor.
  const RelatedRepo({
    required this.name,
    required this.description,
    this.url,
  });

  final String name;
  final String description;
  final String? url;
}

/// A technical decision called out in the Engineering tab.
class EngineeringDecision {
  /// [EngineeringDecision] constructor.
  const EngineeringDecision({
    required this.title,
    required this.detail,
  });

  final String title;
  final String detail;
}

/// Simulated HTTP endpoint for the in-portfolio playground.
class ShowcaseEndpoint {
  /// [ShowcaseEndpoint] constructor.
  const ShowcaseEndpoint({
    required this.id,
    required this.method,
    required this.path,
    required this.summary,
    required this.group,
    required this.requestJson,
    required this.responseJson,
    this.responseStatus = 200,
    this.responseMs = 140,
    this.note,
  });

  final String id;
  final String method;
  final String path;
  final String summary;
  final String group;
  final String requestJson;
  final String responseJson;
  final int responseStatus;
  final int responseMs;
  final String? note;

  /// Status class label, e.g. `201 Created`.
  String get statusLabel {
    const labels = <int, String>{
      200: "OK",
      201: "Created",
      204: "No Content",
    };
    return "$responseStatus ${labels[responseStatus] ?? ""}".trim();
  }
}

/// Relational excerpt shown on the Data tab.
class SchemaGraph {
  /// [SchemaGraph] constructor.
  const SchemaGraph({
    required this.entities,
    required this.relations,
    this.caption,
  });

  final List<SchemaEntity> entities;
  final List<SchemaRelation> relations;
  final String? caption;
}

/// A table in the schema excerpt.
class SchemaEntity {
  /// [SchemaEntity] constructor.
  const SchemaEntity({
    required this.name,
    required this.fields,
  });

  final String name;
  final List<String> fields;
}

/// A foreign-key style link between entities.
class SchemaRelation {
  /// [SchemaRelation] constructor.
  const SchemaRelation({
    required this.from,
    required this.to,
    this.label = "",
  });

  final String from;
  final String to;
  final String label;
}

/// Layered architecture diagram.
class ArchitectureGraph {
  /// [ArchitectureGraph] constructor.
  const ArchitectureGraph({
    required this.layers,
    this.caption,
  });

  /// Top-to-bottom layers; each layer is a row of node labels.
  final List<List<String>> layers;
  final String? caption;
}

/// Infrastructure note under the Infra tab.
class InfraNote {
  /// [InfraNote] constructor.
  const InfraNote({
    required this.label,
    required this.detail,
  });

  final String label;
  final String detail;
}

/// A technology in the Engineering view.
class EngineeringTech {
  /// [EngineeringTech] constructor.
  const EngineeringTech({
    required this.name,
    required this.category,
    required this.caseStudySlugs,
  });

  final String name;
  final String category;
  final List<String> caseStudySlugs;
}

/// Sticky case-study sections.
enum CaseStudySection {
  overview,
  product,
  architecture,
  api,
  data,
  infrastructure,
  engineering,
  results,
}

/// Human label for [CaseStudySection].
extension CaseStudySectionLabel on CaseStudySection {
  /// Title-case nav label.
  String get label => switch (this) {
        CaseStudySection.overview => "Overview",
        CaseStudySection.product => "Product",
        CaseStudySection.architecture => "Architecture",
        CaseStudySection.api => "API",
        CaseStudySection.data => "Data",
        CaseStudySection.infrastructure => "Infrastructure",
        CaseStudySection.engineering => "Engineering",
        CaseStudySection.results => "Results",
      };
}
