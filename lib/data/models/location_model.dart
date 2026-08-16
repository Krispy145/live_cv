/// Physical address used on the CV and map bottom sheet.
class LocationModel {
  /// [LocationModel] constructor.
  const LocationModel({
    this.line1,
    this.line2,
    this.city,
    this.region,
    this.postalCode,
    this.country,
  });

  /// First address line.
  final String? line1;

  /// Second address line.
  final String? line2;

  /// City.
  final String? city;

  /// County / state / region.
  final String? region;

  /// Postal code.
  final String? postalCode;

  /// Country.
  final String? country;

  /// Bishop Auckland fallback used by the map sheet.
  static const bishopAuckland = LocationModel(
    city: "Bishop Auckland",
    region: "County Durham",
    country: "United Kingdom",
  );

  /// Copy with optional overrides.
  LocationModel copyWith({
    String? line1,
    String? line2,
    String? city,
    String? region,
    String? postalCode,
    String? country,
  }) {
    return LocationModel(
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      region: region ?? this.region,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "line1": line1,
      "line2": line2,
      "city": city,
      "region": region,
      "postalCode": postalCode,
      "country": country,
    };
  }

  factory LocationModel.fromMap(Map<String, dynamic> map) {
    return LocationModel(
      line1: map["line1"] as String?,
      line2: map["line2"] as String?,
      city: map["city"] as String?,
      region: map["region"] as String?,
      postalCode: map["postalCode"] as String?,
      country: map["country"] as String?,
    );
  }

  @override
  String toString() {
    return [
      line1,
      line2,
      [city, region].where((part) => part != null && part.isNotEmpty).join(", "),
      postalCode,
      country,
    ].where((part) => part != null && part.isNotEmpty).join("\n");
  }
}
