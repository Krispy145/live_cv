import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/durations.dart';

class CircleImage extends StatelessWidget {
  final bool isAsset;
  final String path;
  const CircleImage({super.key, required this.isAsset, required this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: ClipOval(
        child: isAsset
            ? Image.asset(
                path,
                fit: BoxFit.cover,
                frameBuilder: (BuildContext context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded) {
                    return child;
                  }
                  return AnimatedOpacity(
                    opacity: frame == null ? 0 : 1,
                    duration: Durations.s.duration,
                    curve: Curves.easeOut,
                    child: child,
                  );
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return _buildError();
                },
              )
            : Image.network(
                path,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.blueGrey[700],
                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  );
                },
                errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  return _buildError();
                },
              ),
      ),
    );
  }

  Icon _buildError() {
    return const Icon(
      Icons.error_outline_rounded,
      color: Colors.redAccent,
    );
  }
}
