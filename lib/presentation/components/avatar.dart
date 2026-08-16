import "package:flutter/material.dart";

/// Circular avatar used on the landing header.
class CVAvatar extends StatelessWidget {
  /// [CVAvatar] constructor.
  const CVAvatar({
    super.key,
    required this.width,
    this.image,
  });

  /// Asset or network avatar.
  factory CVAvatar.asset({
    Key? key,
    required double width,
    required String assetPath,
  }) {
    final ImageProvider provider;
    if (assetPath.startsWith("http://") || assetPath.startsWith("https://")) {
      provider = NetworkImage(assetPath);
    } else {
      provider = AssetImage(assetPath);
    }
    return CVAvatar(
      key: key,
      width: width,
      image: provider,
    );
  }

  final double width;
  final ImageProvider? image;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Theme.of(context).colorScheme.surface,
          image: image == null
              ? null
              : DecorationImage(
                  image: image!,
                  fit: BoxFit.cover,
                ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      ),
    );
  }
}
