import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/architecture/footers/footer.dart';
import 'package:live_cv_serverpod_flutter/helpers/durations.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

class DetailsFooterMobile extends Footer {
  final double footerHeight;
  final List<Widget> details;
  DetailsFooterMobile({
    super.key,
    super.backgroundColor,
    this.footerHeight = 164,
    required this.details,
  }) : preferredSize = Size.fromHeight(footerHeight);
  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: AppEdgeInsets.symmetric(vertical: Sizes.m),
      child: Center(
        child: CarouselSlider(
            options: CarouselOptions(height: footerHeight, autoPlay: true, autoPlayInterval: Durations.xxxl.duration, autoPlayAnimationDuration: Durations.l.duration),
            items: details.map((e) => SizedBox.expand(child: e)).toList()),
      ),
    );
  }
}
