import "package:dart_mappable/dart_mappable.dart";
import "package:intl/intl.dart";

part "timeline_model.mapper.dart";

/// A role or qualification shown on the experience / education timelines.
@MappableClass(caseStyle: CaseStyle.snakeCase, ignoreNull: true)
class TimelineModel with TimelineModelMappable {
  /// [TimelineModel] constructor.
  const TimelineModel({
    required this.id,
    required this.title,
    required this.organization,
    this.startDate,
    this.endDate,
    this.dateLabel,
    this.location,
    this.description,
    this.highlights = const [],
    this.skills = const [],
  });

  /// Unique id.
  final String id;

  /// Job title, company, or qualification name.
  final String title;

  /// Company or institution.
  final String organization;

  /// Start date.
  final DateTime? startDate;

  /// End date. `null` means current / ongoing when [startDate] is set.
  final DateTime? endDate;

  /// Optional display override, e.g. `Planned · 11/2025`.
  final String? dateLabel;

  /// Optional location label.
  final String? location;

  /// Short summary.
  final String? description;

  /// Bullet points.
  final List<String> highlights;

  /// Related skills.
  final List<String> skills;

  /// Whether this entry is current.
  bool get isCurrent => startDate != null && endDate == null;

  /// Formatted date range matching the deployed CV, e.g. `01/2020 – Present`.
  String get dateRange {
    if (dateLabel != null && dateLabel!.isNotEmpty) {
      return dateLabel!;
    }
    if (startDate == null) {
      return "";
    }
    final formatter = DateFormat("MM/yyyy");
    final start = formatter.format(startDate!);
    final end = endDate == null ? "Present" : formatter.format(endDate!);
    return "$start – $end";
  }

  /// PDF / heading line, e.g. `Software Developer - Polymorph Systems`.
  String get resumeHeading {
    final role = title.trim();
    final org = organization.trim();
    if (org.isEmpty) {
      return role;
    }
    return "$role - $org";
  }

  static const fromMap = TimelineModelMapper.fromMap;
  static const fromJson = TimelineModelMapper.fromJson;

  /// Default professional experience used when no remote data is available.
  static final List<TimelineModel> experienceData = [
    TimelineModel(
      id: "letsyak",
      title: "Co-Founder & Project Lead",
      organization: "LetsYak",
      startDate: DateTime(2020),
      description:
          "Architected and delivered an education collaboration platform. Owned Flutter app architecture, offline-first data strategies, Firebase Hosting/Firestore integration, and CI/CD pipelines with GitHub Actions. Defined authentication and API contracts, planned releases, and coordinated contributors to ship features that improved team communication and productivity.",
    ),
    TimelineModel(
      id: "digital-oasis",
      title: "Co-Founder",
      organization: "Digital Oasis (Dubai)",
      startDate: DateTime(2023, 12),
      endDate: DateTime(2025, 2),
      location: "Dubai",
      description:
          "Co-founded a SaaS venture delivering mobile apps and admin dashboards. Scoped client solutions, set technical standards, and streamlined delivery using reusable Flutter modules. Led build quality and supported secure API design for production deployments.",
    ),
    TimelineModel(
      id: "take-back-your-mind",
      title: "Flutter Developer (Volunteer)",
      organization: "Take Back Your Mind UK",
      startDate: DateTime(2023, 7),
      endDate: DateTime(2023, 12),
      location: "United Kingdom",
      description:
          "Implemented core screens and messaging flows for a greenfield mental-health app. Contributed to UI/UX and established a maintainable Flutter module structure ready for ongoing contributions.",
    ),
    TimelineModel(
      id: "yellow",
      title: "Flutter Developer",
      organization: "Yellow Software Ltd",
      startDate: DateTime(2022, 7),
      endDate: DateTime(2024, 3),
      location: "London, United Kingdom",
      description:
          "Built and shipped Flutter features across multiple products (including Spotlas). Focused on reliable API clients, robust state management, and mobile performance on Android and iOS. Collaborated with product and backend teams to integrate REST endpoints and improve release stability.",
    ),
    TimelineModel(
      id: "spotlas",
      title: "Flutter Developer",
      organization: "Spotlas",
      startDate: DateTime(2021, 7),
      endDate: DateTime(2022, 7),
      description:
          "Worked in a cross-functional team to design, develop, and release a social discovery app. Delivered reusable UI components, resilient network flows, and analytics instrumentation with an emphasis on performance and state management.",
    ),
    TimelineModel(
      id: "freelance",
      title: "Software Engineer",
      organization: "Freelance Software Engineer",
      startDate: DateTime(2019, 11),
      endDate: DateTime(2021, 6),
      description:
          "Delivered end-to-end mobile and web MVPs for startups: scoped MVPs, implemented Flutter/Python stacks, integrated REST endpoints, and handed over maintainable codebases with documentation.",
    ),
    TimelineModel(
      id: "tab-charters",
      title: "E120 First Officer & Flight Dispatcher",
      organization: "TAB Charters (Pty) Ltd",
      startDate: DateTime(2017, 8),
      endDate: DateTime(2020, 4),
      description:
          "Managed flight operations and dispatch for Embraer 120. Built an internal Flight Following tool for tracking and reporting to improve accuracy and operational visibility. Collaborated with pilots, engineering, and logistics to support safe, efficient operations.",
    ),
    TimelineModel(
      id: "jsf",
      title: "Grade III Flight Instructor",
      organization: "Johannesburg School of Flying",
      startDate: DateTime(2016, 10),
      endDate: DateTime(2017, 3),
      location: "Johannesburg",
      description:
          "Trained students toward PPL. Authored shared ground-school materials and created automated weight-and-balance sheets to improve safety and prep time.",
    ),
  ];

  /// Default education / certification entries.
  static final List<TimelineModel> educationData = [
    TimelineModel(
      id: "ml-foundations",
      title: "Foundations of Machine Learning",
      organization: "Machine Learning Specialization - Coursera (Andrew Ng)",
      startDate: DateTime(2025, 9),
      endDate: DateTime(2025, 10),
      dateLabel: "09/2025 – 10/2025 (In Progress)",
      description:
          "Deepening practical understanding of regression, classification, and model evaluation. Includes applied projects such as a phishing-detection classifier and ML-powered API integration.",
    ),
    const TimelineModel(
      id: "meta-frontend",
      title: "Front-End Development with React",
      organization: "Meta Front-End Developer (React) - Coursera",
      dateLabel: "Planned · 11/2025",
      description: "Covers React fundamentals, hooks, and component design. Emphasis on modern front-end architecture, testing, and developer experience (DX).",
    ),
    const TimelineModel(
      id: "meta-react-native",
      title: "Cross-Platform Mobile Development",
      organization: "Meta React Native Specialization - Coursera",
      dateLabel: "Planned · 12/2025",
      description: "Hands-on training in cross-platform mobile development using React Native and Expo. Focus on authentication, secure storage, and performance optimization.",
    ),
    const TimelineModel(
      id: "security-plus",
      title: "Cybersecurity Fundamentals - Exam Preparation",
      organization: "CompTIA Security+ (SY0-701)",
      dateLabel: "Planned · Early 2026",
      description:
          "Comprehensive study of cybersecurity principles: network defense, IAM, risk mitigation, and incident response. Preparation includes CompTIA-aligned modules covering security architecture and operational resilience.",
    ),
    TimelineModel(
      id: "hyperiondev",
      title: "Software Engineering Bootcamp",
      organization: "HyperionDev, Cape Town",
      startDate: DateTime(2020, 8),
      endDate: DateTime(2021, 2),
      location: "Cape Town",
      description: "Practical Java and Python foundations: data structures, database integration, and core software architecture.",
    ),
    TimelineModel(
      id: "easa-cpl",
      title: "EASA CPL Conversion",
      organization: "AEROS Flight Training, Coventry",
      startDate: DateTime(2019, 5),
      endDate: DateTime(2019, 7),
      location: "Coventry",
      description: "Completed EASA CPL conversion. Current EASA CPL VFR license; future ATPL progression planned.",
    ),
    TimelineModel(
      id: "atpl-credits",
      title: "ATPL Credits with Instrument Rating",
      organization: "43 Air School, Port Alfred",
      startDate: DateTime(2015),
      endDate: DateTime(2016, 2),
      location: "Port Alfred",
      description: "Instrument Rating, Multi-engine, Night Rating (ATP credits). Emphasis on procedures, decision-making, and safety.",
    ),
    TimelineModel(
      id: "cbc-boksburg",
      title: "High School Diploma",
      organization: "Christian Brothers College, Boksburg",
      startDate: DateTime(2000),
      endDate: DateTime(2013, 11),
      location: "Boksburg",
      description: "Head Boy · Head of House · Leadership and Endeavour Awards.",
    ),
  ];
}
