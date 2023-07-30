import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/helpers/gesture_recognizer.dart';
import 'package:url_launcher/url_launcher.dart';

class SVGImage extends StatelessWidget {
  final SourceIcon sourceIcon;
  final Size size;
  final Color? color;
  // final Function()? onTap;
  const SVGImage({
    super.key,
    required this.sourceIcon,
    this.size = const Size(24, 24),
    this.color,
    // this.onTap,
  });

  Future<void> tryLaunchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureRecognizer(
      onTap: () => tryLaunchUrl(sourceIcon.link ?? ""),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.network(
          sourceIcon.path ?? "",
          width: size.width,
          height: size.height,
          colorFilter: ColorFilter.mode(color ?? Colors.white, BlendMode.srcIn),
          placeholderBuilder: (BuildContext context) => Container(
            padding: const EdgeInsets.all(8.0),
            child: const CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }
}
