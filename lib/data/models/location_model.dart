import "package:dart_mappable/dart_mappable.dart";

part "location_model.mapper.dart";

/// Physical address used on the CV and map bottom sheet.
@MappableClass(
  caseStyle: CaseStyle.snakeCase,
  ignoreNull: true,
  generateMethods: GenerateMethods.decode | GenerateMethods.encode | GenerateMethods.copy | GenerateMethods.equals,
)
class LocationModel with LocationModelMappable {
  /// [LocationModel] constructor.
  const LocationModel({
    this.line1,
    this.line2,
    this.city,
    this.region,
    this.postalCode,
    this.country,
    this.latitude,
    this.longitude,
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

  /// Map latitude, stored on the user-details document.
  final double? latitude;

  /// Map longitude, stored on the user-details document.
  final double? longitude;

  /// Whether both map coordinates are present.
  bool get hasCoordinates => latitude != null && longitude != null;

  /// Bishop Auckland fallback used by the map sheet.
  static const bishopAuckland = LocationModel(
    city: "Bishop Auckland",
    region: "County Durham",
    country: "United Kingdom",
    latitude: 54.6561,
    longitude: -1.6770,
  );

  static const fromMap = LocationModelMapper.fromMap;
  static const fromJson = LocationModelMapper.fromJson;

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
