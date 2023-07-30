import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';
import 'package:live_cv_serverpod_flutter/widgets/image_description_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/responsive_layout.dart';

class ImageDescriptionListContainer extends StatelessWidget {
  final String? listHeader;
  final List<ImageDescription> imageDescriptions;
  final Sizes? listPaddingSize;
  final bool responsiveLayout;
  final bool readMoreDialog;
  final Color? textColor;

  final double? width;
  const ImageDescriptionListContainer({
    super.key,
    required this.imageDescriptions,
    this.listHeader,
    this.width,
    this.listPaddingSize,
    this.textColor,
    this.responsiveLayout = false,
    this.readMoreDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppEdgeInsets.all(listPaddingSize ?? Sizes.xxs),
      width: width,
      child: ResponsiveLayout.scrollable(
        padding: AppEdgeInsets.symmetric(vertical: Sizes.m),
        children: [
          Sizes.xl.spacer(vertical: ScreenSize.isMobile),
          if (listHeader != null)
            Text(
              listHeader!,
              style: AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: textColor),
            ),
          ...imageDescriptions
              .map((e) => ImageDescriptionContainer.network(
                    readMoreDialog: readMoreDialog,
                    imageDescription: e,
                    textColor: textColor,
                    responsiveLayout: responsiveLayout,
                    detailsWidth: ScreenSize.isDesktop ? 260 : screenWidth - (Sizes.xl.points() * 2),
                    padding: AppEdgeInsets.symmetric(vertical: ScreenSize.isMobile ? Sizes.xl : null, horizontal: !ScreenSize.isMobile ? Sizes.xl : null),
                  ))
              .toList(),
        ],
      ),
    );
  }
}
