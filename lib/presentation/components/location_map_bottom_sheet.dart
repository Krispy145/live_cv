import "package:cv_package/core/theme/theme_tokens.dart";
import "package:cv_package/data/models/location_model.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_map/flutter_map.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:latlong2/latlong.dart";
import "package:maps/data/models/marker_model.dart";

/// Bottom sheet showing location on a map with address details
class LocationMapBottomSheet extends StatefulWidget {
  final LocationModel location;

  const LocationMapBottomSheet({
    super.key,
    required this.location,
  });

  @override
  State<LocationMapBottomSheet> createState() => _LocationMapBottomSheetState();
}

class _LocationMapBottomSheetState extends State<LocationMapBottomSheet> {
  late final MapController _mapController;
  LatLng? _coordinates;
  MarkerModel? _markerModel;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();

    // Initialize with fallback location immediately
    _coordinates = const LatLng(54.6561, -1.6770);
    _markerModel = MarkerModel(
      id: "location_marker",
      score: 1,
      position: _coordinates!,
    );

    debugPrint("Initialized marker at: ${_markerModel!.position}");

    // Then geocode and update
    _geocodeLocation();
  }

  /// Geocode the location to get coordinates
  Future<void> _geocodeLocation() async {
    try {
      // Geocode the address to get coordinates
      final geocodedCoordinates = await _geocodeAddress(widget.location.toString());

      // If geocoding succeeded, update coordinates and marker
      if (geocodedCoordinates != null) {
        _coordinates = geocodedCoordinates;
        _markerModel = MarkerModel(
          id: "location_marker",
          score: 1,
          position: _coordinates!,
        );

        // Trigger rebuild to show updated marker
        if (mounted) {
          setState(() {});
        }
      }

      // Move map to location after a short delay to ensure map is ready
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && _coordinates != null) {
          _mapController.move(_coordinates!, 13);
        }
      });
    } catch (e) {
      // Geocoding failed, keep fallback location (already set in initState)
      debugPrint("Geocoding failed: $e");
    }
  }

  /// Geocode an address string to LatLng coordinates
  Future<LatLng?> _geocodeAddress(String address) async {
    try {
      // For now, we'll use a simple mapping for common locations
      // In a real implementation, you'd use a geocoding service like:
      // - Google Places API
      // - OpenStreetMap Nominatim API
      // - Mapbox Geocoding API

      final addressLower = address.toLowerCase();

      // Check for Bishop Auckland, County Durham
      if (addressLower.contains("bishop auckland") || addressLower.contains("county durham") || addressLower.contains("durham")) {
        return const LatLng(54.6561, -1.6770);
      }

      // Check for London
      if (addressLower.contains("london")) {
        return const LatLng(51.5074, -0.1278);
      }

      // Check for Manchester
      if (addressLower.contains("manchester")) {
        return const LatLng(53.4808, -2.2426);
      }

      // Check for Birmingham
      if (addressLower.contains("birmingham")) {
        return const LatLng(52.4862, -1.8904);
      }

      // Check for Leeds
      if (addressLower.contains("leeds")) {
        return const LatLng(53.8008, -1.5491);
      }

      // Check for Newcastle
      if (addressLower.contains("newcastle")) {
        return const LatLng(54.9783, -1.6178);
      }

      // Check for Liverpool
      if (addressLower.contains("liverpool")) {
        return const LatLng(53.4084, -2.9916);
      }

      // Check for Sheffield
      if (addressLower.contains("sheffield")) {
        return const LatLng(53.3811, -1.4701);
      }

      // Check for Bristol
      if (addressLower.contains("bristol")) {
        return const LatLng(51.4545, -2.5879);
      }

      // Check for Edinburgh
      if (addressLower.contains("edinburgh")) {
        return const LatLng(55.9533, -3.1883);
      }

      // Check for Glasgow
      if (addressLower.contains("glasgow")) {
        return const LatLng(55.8642, -4.2518);
      }

      // Check for Cardiff
      if (addressLower.contains("cardiff")) {
        return const LatLng(51.4816, -3.1791);
      }

      // Check for Belfast
      if (addressLower.contains("belfast")) {
        return const LatLng(54.5973, -5.9301);
      }

      // If no match found, return null to use fallback
      return null;
    } catch (e) {
      // If geocoding fails, return null to use fallback
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final height = MediaQuery.of(context).size.height * 0.7;

    debugPrint("Building map with marker: ${_markerModel?.position}");

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: tokens.color.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: tokens.color.outline.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(tokens.spacing.lg),
            child: Row(
              children: [
                FaIcon(
                  FontAwesomeIcons.locationDot,
                  color: tokens.color.primary,
                  size: 24,
                ),
                SizedBox(width: tokens.spacing.sm),
                Expanded(
                  child: Text(
                    "My Location",
                    style: tokens.text.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: FaIcon(
                    FontAwesomeIcons.xmark,
                    color: tokens.color.onSurface.withValues(alpha: 0.7),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            flex: 2,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: tokens.spacing.lg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(tokens.card.borderRadius),
                border: Border.all(
                  color: tokens.color.outline.withValues(alpha: 0.2),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(tokens.card.borderRadius),
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _coordinates ?? const LatLng(54.6561, -1.6770),
                    minZoom: 5,
                    maxZoom: 18,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    // Tile layer
                    TileLayer(
                      urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName: "cv_app",
                    ),

                    // Marker layer
                    if (_markerModel != null)
                      MarkerLayer(
                        markers: [
                          Marker(
                            point: _markerModel!.position,
                            width: 80,
                            height: 80,
                            child: FaIcon(
                              FontAwesomeIcons.locationDot,
                              color: tokens.color.onPrimary,
                              size: 48,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Address details
          Expanded(
            child: Container(
              margin: EdgeInsets.all(tokens.spacing.lg),
              padding: EdgeInsets.all(tokens.spacing.lg),
              decoration: BoxDecoration(
                color: tokens.color.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(tokens.card.borderRadius),
                border: Border.all(
                  color: tokens.color.outline.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.house,
                        color: tokens.color.primary,
                        size: 20,
                      ),
                      SizedBox(width: tokens.spacing.sm),
                      Text(
                        "Address",
                        style: tokens.text.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: _copyAddress,
                        icon: FaIcon(
                          FontAwesomeIcons.copy,
                          color: tokens.color.primary,
                          size: 20,
                        ),
                        tooltip: "Copy address",
                      ),
                    ],
                  ),
                  SizedBox(height: tokens.spacing.sm),
                  Expanded(
                    child: Text(
                      widget.location.toString(),
                      style: tokens.text.bodyMedium?.copyWith(
                        color: tokens.color.onSurface.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Copy address to clipboard
  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: widget.location.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Address copied to clipboard"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
