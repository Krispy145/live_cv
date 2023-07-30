import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';
import 'package:live_cv_serverpod_flutter/widgets/description_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/responsive_layout.dart';

class DescriptionListContainer extends StatelessWidget {
  final String? listHeader;
  final List<Description> descriptions;
  final AppEdgeInsets? listPadding;
  final double? width;
  final bool responsiveLayout;
  final Color? textColor;
  const DescriptionListContainer({
    super.key,
    required this.descriptions,
    this.listHeader,
    this.width,
    this.listPadding,
    this.textColor,
    this.responsiveLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: listPadding ?? AppEdgeInsets.all(Sizes.xxs),
      width: width,
      child: responsiveLayout
          ? ResponsiveLayout.scrollable(
              padding: AppEdgeInsets.symmetric(vertical: Sizes.m),
              children: _buildContents(),
            )
          : Column(
              children: _buildContents(),
            ),
    );
  }

  List<Widget> _buildContents() {
    return [
      if (listHeader != null)
        Text(
          listHeader!,
          style: AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: textColor),
        ),
      Sizes.s.spacer(vertical: ScreenSize.isDesktop),
      ...descriptions
          .map((e) => DescriptionContainer(
                description: e,
                padding: listPadding,
                textColor: textColor,
              ))
          .toList(),
    ];
  }
}
