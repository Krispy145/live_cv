import "dart:math" as math;

import "package:flutter/material.dart";

/// Wraps [child] with an arc of [bannerText].
class ProfileWithArcBanner extends StatelessWidget {
  /// [ProfileWithArcBanner] constructor.
  const ProfileWithArcBanner({
    super.key,
    required this.child,
    required this.bannerText,
    required this.arcRadius,
    required this.sweepAngle,
    required this.color,
    required this.textStyle,
  });

  final Widget child;
  final String bannerText;
  final double arcRadius;
  final double sweepAngle;
  final Color color;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        child,
        IgnorePointer(
          child: CustomPaint(
            size: Size(arcRadius * 2.4, arcRadius * 2.4),
            painter: _ArcBannerPainter(
              text: bannerText,
              radius: arcRadius,
              sweepAngle: sweepAngle,
              color: color,
              textStyle: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}

class _ArcBannerPainter extends CustomPainter {
  _ArcBannerPainter({
    required this.text,
    required this.radius,
    required this.sweepAngle,
    required this.color,
    required this.textStyle,
  });

  final String text;
  final double radius;
  final double sweepAngle;
  final Color color;
  final TextStyle textStyle;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final startAngle = -math.pi / 2 - sweepAngle / 2;
    final characters = text.split("");
    if (characters.isEmpty) {
      return;
    }
    final step = sweepAngle / math.max(characters.length - 1, 1);

    for (var i = 0; i < characters.length; i++) {
      final angle = startAngle + (step * i);
      final offset = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      final textPainter = TextPainter(
        text: TextSpan(text: characters[i], style: textStyle.copyWith(color: color)),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(offset.dx, offset.dy);
      canvas.rotate(angle + math.pi / 2);
      textPainter.paint(canvas, Offset(-textPainter.width / 2, -textPainter.height / 2));
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ArcBannerPainter oldDelegate) {
    return oldDelegate.text != text || oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
