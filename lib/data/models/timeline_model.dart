import "package:intl/intl.dart";

/// A role or qualification shown on the experience / education timelines.
class TimelineModel {
  /// [TimelineModel] constructor.
  const TimelineModel({
    required this.id,
    required this.title,
    required this.organization,
    required this.startDate,
    this.endDate,
    this.location,
    this.description,
    this.highlights = const [],
    this.skills = const [],
  });

  /// Unique id.
  final String id;

  /// Job title or qualification name.
  final String title;

  /// Company or institution.
  final String organization;

  /// Start date.
  final DateTime startDate;

  /// End date. `null` means current / ongoing.
  final DateTime? endDate;

  /// Optional location label.
  final String? location;

  /// Short summary.
  final String? description;

  /// Bullet points.
  final List<String> highlights;

  /// Related skills.
  final List<String> skills;

  /// Whether this entry is current.
  bool get isCurrent => endDate == null;

  /// Formatted date range, e.g. `Jun 2021 – Mar 2024`.
  String get dateRange {
    final formatter = DateFormat("MMM yyyy");
    final start = formatter.format(startDate);
    final end = endDate == null ? "Present" : formatter.format(endDate!);
    return "$start – $end";
  }

  TimelineModel copyWith({
    String? id,
    String? title,
    String? organization,
    DateTime? startDate,
    DateTime? endDate,
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
      "startDate": startDate.toIso8601String(),
      "endDate": endDate?.toIso8601String(),
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
      startDate: DateTime.tryParse(map["startDate"] as String? ?? "") ?? DateTime.now(),
      endDate: DateTime.tryParse(map["endDate"] as String? ?? ""),
      location: map["location"] as String?,
      description: map["description"] as String?,
      highlights: (map["highlights"] as List?)?.cast<String>() ?? const [],
      skills: (map["skills"] as List?)?.cast<String>() ?? const [],
    );
  }

  /// Default professional experience used when no remote data is available.
  static final List<TimelineModel> experienceData = [
    TimelineModel(
      id: "polymorph",
      title: "Software Developer",
      organization: "Polymorph Systems",
      startDate: DateTime(2025, 3),
      location: "United Kingdom",
      description: "Building production Flutter applications and shared package infrastructure.",
      highlights: [
        "Delivering cross-platform Flutter features across web and mobile.",
        "Working with shared internal packages for theming, navigation, and data sources.",
      ],
      skills: ["Flutter", "Dart", "Firebase"],
    ),
    TimelineModel(
      id: "lets-yak",
      title: "Co-Founder",
      organization: "Let's Yak",
      startDate: DateTime(2024, 1),
      location: "United Kingdom",
      description: "Co-founded a product studio building Flutter applications and reusable packages.",
      highlights: [
        "Designed and shipped multi-flavor Flutter apps with Firebase, theming, and CI/CD.",
        "Built a shared package ecosystem covering navigation, maps, forms, and utilities.",
      ],
      skills: ["Flutter", "Dart", "Firebase", "Fastlane"],
    ),
    TimelineModel(
      id: "digital-oasis",
      title: "Co-Founder",
      organization: "Digital Oasis",
      startDate: DateTime(2023, 6),
      endDate: DateTime(2025, 2),
      location: "United Kingdom",
      description: "Co-founded a digital product company focused on Flutter and Firebase applications.",
      highlights: [
        "Led end-to-end product delivery from architecture through store and web release.",
        "Established design-token theming and reusable UI systems across products.",
      ],
      skills: ["Flutter", "Firebase", "Product"],
    ),
    TimelineModel(
      id: "yellow",
      title: "Flutter Developer",
      organization: "Yellow",
      startDate: DateTime(2022, 6),
      endDate: DateTime(2024, 3),
      location: "London, United Kingdom",
      description: "Promoted from Spotlas into Yellow, building discovery and ordering experiences.",
      highlights: [
        "Designed, developed, and shipped Flutter features for consumer-facing products.",
        "Collaborated across design and backend teams on production releases.",
      ],
      skills: ["Flutter", "Dart", "APIs"],
    ),
    TimelineModel(
      id: "spotlas",
      title: "Flutter Developer",
      organization: "Spotlas",
      startDate: DateTime(2021, 6),
      endDate: DateTime(2022, 6),
      location: "London, United Kingdom",
      description: "Built features for a social discovery app helping people find and share spots.",
      highlights: [
        "Implemented Flutter UI and data flows in a production mobile application.",
        "Worked in a team shipping regular app-store releases.",
      ],
      skills: ["Flutter", "Dart", "Mobile"],
    ),
  ];

  /// Default education / certification entries.
  static final List<TimelineModel> educationData = [
    TimelineModel(
      id: "ml-specialization",
      title: "Machine Learning Specialization",
      organization: "DeepLearning.AI / Stanford (Andrew Ng)",
      startDate: DateTime(2025, 10),
      location: "Online",
      description: "Rebuilding ML foundations covering supervised learning, advanced algorithms, and unsupervised learning.",
      highlights: [
        "Linear and multivariate regression, evaluation metrics, and applied notebooks.",
        "Progress tracked publicly via the AI + Cybersecurity roadmap.",
      ],
      skills: ["Python", "Machine Learning"],
    ),
    TimelineModel(
      id: "security-plus",
      title: "CompTIA Security+",
      organization: "CompTIA",
      startDate: DateTime(2025, 12),
      location: "United Kingdom",
      description: "Security+ certification preparation covering core cybersecurity concepts and controls.",
      highlights: [
        "Integrated into the public AI + Cybersecurity learning roadmap.",
      ],
      skills: ["Cybersecurity"],
    ),
  ];
}
