import "package:cv_app/data/models/header_model.dart";
import "package:cv_app/data/models/location_model.dart";
import "package:cv_app/dependencies/injection.dart";
import "package:cv_app/presentation/components/location_map_bottom_sheet.dart";
import "package:cv_app/presentation/landing/components/radial_contact_menu.dart";
import "package:flutter/material.dart";
import "package:url_launcher/url_launcher.dart";

/// Floating contact control used on every portfolio page.
class ContactOverlay extends StatelessWidget {
  /// [ContactOverlay] constructor.
  const ContactOverlay({super.key});

  HeaderModel get _header => Managers.appWrapperStore.headerModel;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32,
      right: 32,
      child: RadialContactMenu(
        onContactSelected: (type) => _handle(context, type),
      ),
    );
  }

  void _handle(BuildContext context, ContactType contactType) {
    final userDetails = _header.userDetails;
    switch (contactType) {
      case ContactType.email:
        if (userDetails.email != null) {
          _launch("mailto:${userDetails.email}");
        }
      case ContactType.phone:
        if (userDetails.phone != null) {
          _launch("tel:${userDetails.phone}");
        }
      case ContactType.github:
        if (userDetails.githubUrl != null) {
          _launch(userDetails.githubUrl!);
        }
      case ContactType.linkedin:
        if (userDetails.linkedinUrl != null) {
          _launch(userDetails.linkedinUrl!);
        }
      case ContactType.location:
        final details = Managers.appWrapperStore.userDetails ?? userDetails;
        final canEdit = Managers.config.showDevTools;
        if (details.location == null && !canEdit) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Location information not available")),
          );
          return;
        }
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => LocationMapBottomSheet(
            location: details.location ?? const LocationModel(),
            email: details.email,
            phone: details.phone,
            canEdit: canEdit,
          ),
        );
    }
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
