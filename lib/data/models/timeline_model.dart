import "package:intl/intl.dart";

/// A role or qualification shown on the experience / education timelines.
class TimelineModel {
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

  TimelineModel copyWith({
    String? id,
    String? title,
    String? organization,
    DateTime? startDate,
    DateTime? endDate,
    String? dateLabel,
    String? location,
    String? description,
    List<String>? highlights,
    List<String>? skills,
  }) {
    return TimelineModel(
      id: id ?? this.id,
      title: title ?? this.title,
      organization: organization ?? this.organization,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      dateLabel: dateLabel ?? this.dateLabel,
      location: location ?? this.location,
      description: description ?? this.description,
      highlights: highlights ?? this.highlights,
      skills: skills ?? this.skills,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "organization": organization,
      "startDate": startDate?.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
      "dateLabel": dateLabel,
      "location": location,
      "description": description,
      "highlights": highlights,
      "skills": skills,
    };
  }

  factory TimelineModel.fromMap(Map<String, dynamic> map) {
    return TimelineModel(
      id: map["id"] as String? ?? "",
      title: map["title"] as String? ?? "",
      organization: map["organization"] as String? ?? "",
      startDate: DateTime.tryParse(map["startDate"] as String? ?? ""),
      endDate: DateTime.tryParse(map["endDate"] as String? ?? ""),
      dateLabel: map["dateLabel"] as String?,
      location: map["location"] as String?,
      description: map["description"] as String?,
      highlights: (map["highlights"] as List?)?.cast<String>() ?? const [],
      skills: (map["skills"] as List?)?.cast<String>() ?? const [],
    );
  }

  /// Default professional experience used when no remote data is available.
  static final List<TimelineModel> experienceData = [
    TimelineModel(
      id: "letsyak",
      title: "LetsYak",
      organization: "LetsYak",
      startDate: DateTime(2020),
      description:
          "Architected and delivered an education collaboration platform. Owned Flutter app architecture, offline-first data strategies, Firebase Hosting/Firestore integration, and CI/CD pipelines with GitHub Actions. Defined authentication and API contracts, planned releases, and coordinated contributors to ship features that improved team communication and productivity.",
    ),
    TimelineModel(
      id: "digital-oasis",
      title: "Digital Oasis (Dubai)",
      organization: "Digital Oasis",
      startDate: DateTime(2023, 12),
      endDate: DateTime(2025, 2),
      location: "Dubai",
      description:
          "Co-founded a SaaS venture delivering mobile apps and admin dashboards. Scoped client solutions, set technical standards, and streamlined delivery using reusable Flutter modules. Led build quality and supported secure API design for production deployments.",
    ),
    TimelineModel(
      id: "take-back-your-mind",
      title: "Take Back Your Mind UK",
      organization: "Take Back Your Mind UK",
      startDate: DateTime(2023, 7),
      endDate: DateTime(2023, 12),
      location: "United Kingdom",
      description:
          "Implemented core screens and messaging flows for a greenfield mental-health app. Contributed to UI/UX and established a maintainable Flutter module structure ready for ongoing contributions.",
    ),
    TimelineModel(
      id: "yellow",
      title: "Yellow Software Ltd",
      organization: "Yellow Software Ltd",
      startDate: DateTime(2022, 7),
      endDate: DateTime(2024, 3),
      location: "London, United Kingdom",
      description: "Designed, developed, and shipped Flutter features for consumer-facing discovery and ordering products. Collaborated across design and backend teams on production releases.",
    ),
  ];

  /// Default education / certification entries.
  static final List<TimelineModel> educationData = [
    TimelineModel(
      id: "ml-specialization",
      title: "Machine Learning Specialization — Coursera (Andrew Ng)",
      organization: "Coursera / DeepLearning.AI",
      startDate: DateTime(2025, 9),
      endDate: DateTime(2025, 10),
      dateLabel: "09/2025 – 10/2025 (In Progress)",
      description:
          "Deepening practical understanding of regression, classification, and model evaluation. Includes applied projects such as a phishing-detection classifier and ML-powered API integration.",
    ),
    const TimelineModel(
      id: "meta-frontend",
      title: "Meta Front-End Developer (React) — Coursera",
      organization: "Coursera / Meta",
      dateLabel: "Planned · 11/2025",
      description: "Covers React fundamentals, hooks, and component design. Emphasis on modern front-end architecture, testing, and developer experience (DX).",
    ),
    const TimelineModel(
      id: "meta-react-native",
      title: "Meta React Native Specialization — Coursera",
      organization: "Coursera / Meta",
      dateLabel: "Planned · 12/2025",
      description: "Hands-on training in cross-platform mobile development using React Native and Expo. Focus on authentication, secure storage, and performance optimization.",
    ),
    const TimelineModel(
      id: "security-plus",
      title: "CompTIA Security+ (SY0-701)",
      organization: "CompTIA",
      dateLabel: "Planned · Early 2026",
      description:
          "Comprehensive study of cybersecurity principles: network defense, IAM, risk mitigation, and incident response. Preparation includes CompTIA-aligned modules covering security architecture and operational resilience.",
    ),
  ];
}
