import "package:cv_package/data/models/header_model.dart";
import "package:cv_package/presentation/components/avatar.dart";
import "package:flutter/material.dart";
import "package:theme/extensions/build_context.dart";
import "package:utilities/helpers/extensions/build_context.dart";
import "package:utilities/sizes/spacers.dart";

class HeaderView extends StatelessWidget {
  final HeaderModel headerModel;
  const HeaderView({super.key, required this.headerModel});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.colorScheme.primary,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: context.screenHeight - 148,
        ),
        child: _buildHeader(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Sizes.xl.spacer(),
          Banner(
            message: "Open to work",
            location: BannerLocation.bottomStart,
            color: context.colorScheme.primary,
            textStyle: context.textTheme.bodySmall?.copyWith(
                  color: context.colorScheme.onPrimary,
                ) ??
                TextStyle(
                  color: context.colorScheme.onPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
            child: CVAvatar.asset(
              width: context.screenWidth * 0.2 < 200 ? 200 : context.screenWidth * 0.2,
              assetPath: headerModel.userDetails.imageUrl ?? "https://via.placeholder.com/150",
            ),
          ),
          Sizes.xl.spacer(),
          Divider(
            color: context.colorScheme.onPrimary,
            thickness: 4,
            endIndent: context.screenWidth * 0.2,
            indent: context.screenWidth * 0.2,
          ),
          Sizes.xl.spacer(),
          Text(
            headerModel.title,
            textAlign: TextAlign.center,
            style: context.textTheme.headlineMedium?.copyWith(
              color: context.colorScheme.onPrimary,
            ),
          ),
          if (headerModel.subtitle != null) ...[
            Sizes.xl.spacer(),
            Text(
              headerModel.subtitle!,
              textAlign: TextAlign.center,
              style: context.textTheme.headlineSmall?.copyWith(
                color: context.colorScheme.onPrimary,
              ),
            ),
          ],
          if (headerModel.skillsPairs.isNotEmpty) ...[
            Sizes.l.spacer(),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: headerModel.skills
                    .map(
                      (skill) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: Chip(
                          label: Text(
                            skill.name,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
          Sizes.xl.spacer(),
        ],
      ),
    );
  }
}
