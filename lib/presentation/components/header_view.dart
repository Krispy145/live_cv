import "dart:math";

import "package:cv_package/core/theme/theme_tokens.dart";
import "package:cv_package/data/models/header_model.dart";
import "package:cv_package/presentation/components/avatar.dart";
import "package:cv_package/presentation/components/curved_banner.dart";
import "package:flutter/material.dart";
import "package:utilities/helpers/extensions/build_context.dart";

class HeaderView extends StatelessWidget {
  final HeaderModel headerModel;
  const HeaderView({super.key, required this.headerModel});

  @override
  Widget build(BuildContext context) {
    final tokens = ThemeTokens.of(context);

    return Container(
      width: double.infinity,
      color: tokens.color.primary,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: context.screenHeight - 148,
        ),
        child: _buildHeader(context),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final tokens = ThemeTokens.of(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: tokens.spacing.xxl),

          // Avatar with banner
          ProfileWithArcBanner(
            bannerText: "Open to work",
            arcRadius: 80,
            sweepAngle: pi / 2,
            color: tokens.color.onPrimary,
            textStyle: tokens.text.chipLabel.copyWith(
              color: tokens.color.primary,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
            child: CVAvatar.asset(
              width: context.screenWidth * 0.2 < 200 ? 200 : context.screenWidth * 0.2,
              assetPath: headerModel.userDetails.imageUrl ?? "https://via.placeholder.com/150",
            ),
          ),

          SizedBox(height: tokens.spacing.xxl),

          // Decorative divider
          Container(
            height: 4,
            width: context.screenWidth * 0.3,
            decoration: BoxDecoration(
              color: tokens.color.onPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          SizedBox(height: tokens.spacing.xxl),

          // Main title
          Text(
            headerModel.title,
            textAlign: TextAlign.center,
            style: tokens.text.heroTitle.copyWith(
              color: tokens.color.onPrimary,
            ),
          ),

          // Subtitle
          if (headerModel.subtitle != null) ...[
            SizedBox(height: tokens.spacing.lg),
            Text(
              headerModel.subtitle!,
              textAlign: TextAlign.center,
              style: tokens.text.titleLarge?.copyWith(
                color: tokens.color.onPrimary.withValues(alpha: 0.9),
                fontWeight: FontWeight.w400,
              ),
            ),
          ],

          // Skills chips
          if (headerModel.skillsPairs.isNotEmpty) ...[
            SizedBox(height: tokens.spacing.xl),
            _buildFadingScrollView(
              context,
              children: headerModel.skills
                  .map(
                    (skill) => Padding(
                      padding: EdgeInsets.symmetric(horizontal: tokens.spacing.xs),
                      child: Chip(
                        label: Text(skill.name),
                        labelStyle: tokens.chip.labelStyle.copyWith(
                          color: tokens.color.primary,
                          fontWeight: FontWeight.w600,
                        ),
                        backgroundColor: tokens.color.onPrimary.withValues(alpha: 0.15),
                        side: BorderSide(
                          color: tokens.color.primary.withValues(alpha: 0.3),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],
          SizedBox(height: tokens.spacing.xxl),
        ],
      ),
    );
  }

  Widget _buildFadingScrollView(BuildContext context, {required List<Widget> children}) {
    final tokens = ThemeTokens.of(context);

    return SizedBox(
      height: 40, // Fixed height for the scroll area
      child: Stack(
        children: [
          // Scrollable content with proper clipping
          Positioned.fill(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: tokens.spacing.xl),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: children,
                ),
              ),
            ),
          ),
          // Left fade overlay
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  stops: const [0.0, 0.3, 0.7, 1.0],
                  colors: [
                    tokens.color.primary, // Match the gradient background
                    tokens.color.primary.withValues(alpha: 0.8),
                    tokens.color.primary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Right fade overlay
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  stops: const [0.0, 0.3, 0.7, 1.0],
                  colors: [
                    tokens.color.primary, // Match the gradient background
                    tokens.color.primary.withValues(alpha: 0.8),
                    tokens.color.primary.withValues(alpha: 0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
