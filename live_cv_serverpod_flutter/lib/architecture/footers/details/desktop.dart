import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/footers/footer.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

class DetailsFooterDesktop extends Footer {
  final double footerHeight;
  final List<Widget> details;
  DetailsFooterDesktop({
    super.key,
    super.backgroundColor,
    this.footerHeight = 190,
    required this.details,
  }) : preferredSize = Size.fromHeight(footerHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: AppEdgeInsets.symmetric(vertical: Sizes.m),
      height: footerHeight,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: details.map((e) => e).toList(),
      ),
    );
  }
}
