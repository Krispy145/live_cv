import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/helpers/container/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/gesture_recognizer.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/screen_size.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';
import 'package:live_cv_serverpod_flutter/helpers/wrappers/expandable.dart';
import 'package:live_cv_serverpod_flutter/widgets/description_container.dart';

class ExpandableContainer extends StatefulWidget {
  final String title;
  final List<Description> information;
  final Color? backgroundColor;
  final Color? textColor;
  final CrossAxisAlignment? crossAxisAlignment;
  const ExpandableContainer({
    super.key,
    required this.title,
    required this.information,
    this.backgroundColor,
    this.textColor,
    this.crossAxisAlignment,
  });

  @override
  State<ExpandableContainer> createState() => _ExpandableContainerState();
}

class _ExpandableContainerState extends State<ExpandableContainer> {
  bool isExpanded = false;
  void toggleExpanded() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  TextStyle? titleTextStyle = AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: Colors.white);

  void setTitleTextStyle(bool isHovering) => setState(() {
        isHovering
            ? titleTextStyle = AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: const Color(0XFF148F79))
            : titleTextStyle = AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: Colors.white);
      });
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      color: widget.backgroundColor ?? Colors.blueGrey[700],
      shape: const AppShape.rectangle(radius: AppBorderRadius.rectangleXXXXXXRounded),
      margin: AppEdgeInsets.symmetric(horizontal: Sizes.xl, vertical: Sizes.m),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              Sizes.m.spacer(),
              GestureRecognizer(
                onTap: toggleExpanded,
                onHover: (isHovering) => setTitleTextStyle(isHovering),
                child: Text(
                  widget.title,
                  style: titleTextStyle,
                ),
              ),
              Sizes.m.spacer(),
              GestureRecognizer(
                onTap: toggleExpanded,
                child: ExpandableWrapper.fromTop(
                    expand: isExpanded,
                    child: Column(
                      children: widget.information
                          .map<Widget>((e) => DescriptionContainer(
                                width: screenWidth - (Sizes.xl.points() * 2),
                                crossAxisAlignment: widget.crossAxisAlignment ?? CrossAxisAlignment.start,
                                textColor: widget.textColor,
                                padding: AppEdgeInsets.only(left: Sizes.xxl, right: Sizes.xxl),
                                description: e,
                              ))
                          .toList()
                        ..add(Sizes.xl.spacer()),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
