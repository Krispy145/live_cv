import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/enums/description.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';
import 'package:live_cv_serverpod_flutter/widgets/circle_image.dart';
import 'package:live_cv_serverpod_flutter/widgets/read_more_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/responsive_layout.dart';

class ImageDescriptionContainer extends StatelessWidget {
  final ImageDescription imageDescription;
  final bool isAsset;
  final double? detailsWidth;
  final bool responsiveLayout;
  final Color? backgroundColor;
  final Color? textColor;
  final AppEdgeInsets? padding;
  final int maxDescriptionCharacters;
  final bool readMoreDialog;
  const ImageDescriptionContainer.network({
    super.key,
    required this.imageDescription,
    this.textColor,
    this.isAsset = false,
    this.detailsWidth,
    this.responsiveLayout = false,
    this.backgroundColor,
    this.padding,
    this.maxDescriptionCharacters = 150,
    this.readMoreDialog = false,
  });
  const ImageDescriptionContainer.asset({
    super.key,
    required this.imageDescription,
    this.textColor,
    this.isAsset = true,
    this.detailsWidth,
    this.responsiveLayout = false,
    this.backgroundColor,
    this.padding,
    this.maxDescriptionCharacters = 150,
    this.readMoreDialog = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: padding,
      child: responsiveLayout
          ? ResponsiveLayout(
              children: _buildChildren(),
            )
          : Column(
              children: _buildChildren(),
            ),
    );
  }

  List<Widget> _buildChildren() {
    return [
      Sizes.m.spacer(),
      CircleImage(isAsset: isAsset, path: imageDescription.path ?? ""),
      if (imageDescription.subheader != null || imageDescription.paragraph != null) Sizes.m.spacer(vertical: responsiveLayout ? ScreenSize.isMobile : true),
      SizedBox(
          width: detailsWidth,
          child: ReadMoreContainer(
            readMoreDialog: readMoreDialog,
            subheader: imageDescription.subheader,
            textColor: textColor,
            path: imageDescription.path,
            type: DescriptionType.values.firstWhere((type) => type.name == imageDescription.type),
            paragraph: [imageDescription.paragraph],
            maxCharacters: maxDescriptionCharacters,
          ))
    ];
  }
}
