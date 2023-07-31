import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/buttons/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/border_radius.dart';
import 'package:live_cv_serverpod_flutter/helpers/extensions/string.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/scaling.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';

enum Skills { flutter, firebase, go, javascript }

class SkillsFlag extends StatelessWidget {
  const SkillsFlag({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blueGrey[700],
      padding: AppEdgeInsets.only(bottom: Sizes.xl, left: Sizes.xl, right: Sizes.xl),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: Skills.values.map((e) => _buildSkill(e.name.toTitleCase())).toList(),
        ),
      ),
    );
  }

  Widget _buildSkill(String skill) {
    return Padding(
      padding: AppEdgeInsets.symmetric(horizontal: Sizes.xs),
      child: Material(
          color: const Color(0XFF148F79),
          borderRadius: AppBorderRadius.pill.borderRadius(),
          elevation: 8,
          child: Button.textPill(
            buttonText: skill,
            horizontalScaling: const ScalingStyle.shrink(),
          )),
    );
  }
}
