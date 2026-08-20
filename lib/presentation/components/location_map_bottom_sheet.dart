import "package:cv_app/core/theme/theme_tokens.dart";
import "package:cv_app/data/models/location_model.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_map/flutter_map.dart";
import "package:font_awesome_flutter/font_awesome_flutter.dart";
import "package:latlong2/latlong.dart";
import "package:maps/data/models/marker_model.dart";
import "package:utilities/data/sources/source.dart";

/// Bottom sheet showing location on a map with address details
class LocationMapBottomSheet extends StatefulWidget {
  final LocationModel location;
  final String? email;
  final String? phone;
  final bool canEdit;

  const LocationMapBottomSheet({
    super.key,
    required this.location,
    this.email,
    this.phone,
    this.canEdit = false,
  });

  @override
  State<LocationMapBottomSheet> createState() => _LocationMapBottomSheetState();
}

class _LocationMapBottomSheetState extends State<LocationMapBottomSheet> {
  late final MapController _mapController;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _line1;
  late final TextEditingController _line2;
  late final TextEditingController _city;
  late final TextEditingController _region;
  late final TextEditingController _postalCode;
  late final TextEditingController _country;
  late final TextEditingController _latitude;
  late final TextEditingController _longitude;
  LatLng? _coordinates;
  MarkerModel? _markerModel;
  bool _saving = false;
  bool _mapReady = false;

  static const _fallbackCoordinates = LatLng(54.6561, -1.6770);

  LocationModel get _location => LocationModel(
        line1: _blankToNull(_line1.text),
        line2: _blankToNull(_line2.text),
        city: _blankToNull(_city.text),
        region: _blankToNull(_region.text),
        postalCode: _blankToNull(_postalCode.text),
        country: _blankToNull(_country.text),
        latitude: _parseCoordinate(_latitude.text),
        longitude: _parseCoordinate(_longitude.text),
      );

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    final location = widget.location;
    _email = TextEditingController(text: widget.email ?? "");
    _phone = TextEditingController(text: widget.phone ?? "");
    _line1 = TextEditingController(text: location.line1 ?? "");
    _line2 = TextEditingController(text: location.line2 ?? "");
    _city = TextEditingController(text: location.city ?? "");
    _region = TextEditingController(text: location.region ?? "");
    _postalCode = TextEditingController(text: location.postalCode ?? "");
    _country = TextEditingController(text: location.country ?? "");
    _latitude = TextEditingController(text: location.latitude?.toString() ?? "");
    _longitude = TextEditingController(text: location.longitude?.toString() ?? "");

    _setCoordinates(
      location.hasCoordinates ? LatLng(location.latitude!, location.longitude!) : _fallbackCoordinates,
      updateFields: false,
      rebuild: false,
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _phone.dispose();
    _line1.dispose();
    _line2.dispose();
    _city.dispose();
    _region.dispose();
    _postalCode.dispose();
    _country.dispose();
    _latitude.dispose();
    _longitude.dispose();
    super.dispose();
  }

  void _setCoordinates(LatLng point, {bool updateFields = true, bool rebuild = true}) {
    _coordinates = point;
    _markerModel = MarkerModel(
      id: "location_marker",
      score: 1,
      position: point,
    );
    if (updateFields) {
      _latitude.text = point.latitude.toStringAsFixed(6);
      _longitude.text = point.longitude.toStringAsFixed(6);
    }
    if (rebuild && mounted) {
      setState(() {});
    }
    if (_mapReady) {
      _mapController.move(point, _mapController.camera.zoom);
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);
    final height = MediaQuery.of(context).size.height * 0.85;

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
            flex: widget.canEdit ? 1 : 2,
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
                    initialCenter: _coordinates ?? _fallbackCoordinates,
                    minZoom: 5,
                    maxZoom: 18,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                    onMapReady: () {
                      _mapReady = true;
                      if (_coordinates != null) {
                        _mapController.move(_coordinates!, 13);
                      }
                    },
                    onTap: widget.canEdit
                        ? (tapPosition, point) => _setCoordinates(point)
                        : null,
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
                              color: tokens.color.primary,
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
            flex: widget.canEdit ? 2 : 1,
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
              child: widget.canEdit ? _editForm(tokens) : _addressView(tokens),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressView(ThemeTokens tokens) {
    return Column(
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
            _location.toString(),
            style: tokens.text.bodyMedium?.copyWith(
              color: tokens.color.onSurface.withValues(alpha: 0.8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _editForm(ThemeTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            FaIcon(
              FontAwesomeIcons.penToSquare,
              color: tokens.color.primary,
              size: 20,
            ),
            SizedBox(width: tokens.spacing.sm),
            Expanded(
              child: Text(
                "Edit contact details",
                style: tokens.text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            FilledButton.icon(
              onPressed: _saving ? null : _saveContactDetails,
              icon: _saving
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save, size: 18),
              label: Text(_saving ? "Saving" : "Save"),
            ),
          ],
        ),
        SizedBox(height: tokens.spacing.md),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email"),
                ),
                SizedBox(height: tokens.spacing.sm),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone"),
                ),
                SizedBox(height: tokens.spacing.sm),
                TextField(
                  controller: _line1,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: "Address line 1"),
                ),
                SizedBox(height: tokens.spacing.sm),
                TextField(
                  controller: _line2,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: "Address line 2"),
                ),
                SizedBox(height: tokens.spacing.sm),
                TextField(
                  controller: _city,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: "City"),
                ),
                SizedBox(height: tokens.spacing.sm),
                TextField(
                  controller: _region,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: "County / region"),
                ),
                SizedBox(height: tokens.spacing.sm),
                TextField(
                  controller: _postalCode,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: "Postal code"),
                ),
                SizedBox(height: tokens.spacing.sm),
                TextField(
                  controller: _country,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(labelText: "Country"),
                ),
                SizedBox(height: tokens.spacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _latitude,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(labelText: "Latitude"),
                        onSubmitted: (_) => _applyCoordinatesFromFields(),
                      ),
                    ),
                    SizedBox(width: tokens.spacing.sm),
                    Expanded(
                      child: TextField(
                        controller: _longitude,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        decoration: const InputDecoration(labelText: "Longitude"),
                        onSubmitted: (_) => _applyCoordinatesFromFields(),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: tokens.spacing.sm),
                Text(
                  "Tap the map to drop a pin, or enter latitude and longitude.",
                  style: tokens.text.bodySmall?.copyWith(
                    color: tokens.color.onSurface.withValues(alpha: 0.65),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _saveContactDetails() async {
    setState(() => _saving = true);
    final response = await Managers.appWrapperStore.updateContactDetails(
      email: _blankToNull(_email.text),
      phone: _blankToNull(_phone.text),
      location: _location,
    );
    if (!mounted) {
      return;
    }
    setState(() => _saving = false);
    final succeeded = response == RequestResponse.success;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(succeeded ? "Contact details saved" : "Failed to save contact details"),
        duration: const Duration(seconds: 2),
      ),
    );
    if (succeeded) {
      _applyCoordinatesFromFields();
    }
  }

  void _applyCoordinatesFromFields() {
    final latitude = _parseCoordinate(_latitude.text);
    final longitude = _parseCoordinate(_longitude.text);
    if (latitude == null || longitude == null) {
      return;
    }
    _setCoordinates(LatLng(latitude, longitude), updateFields: false);
  }

  /// Copy address to clipboard
  void _copyAddress() {
    Clipboard.setData(ClipboardData(text: _location.toString()));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Address copied to clipboard"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  String? _blankToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  double? _parseCoordinate(String value) {
    return double.tryParse(value.trim());
  }
}
