import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_client/live_cv_serverpod_client.dart';
import 'package:live_cv_serverpod_flutter/config/theme/app_theme.dart';
import 'package:live_cv_serverpod_flutter/enums/description.dart';
import 'package:live_cv_serverpod_flutter/helpers/buttons/import.dart';
import 'package:live_cv_serverpod_flutter/helpers/extensions/list.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/edge_insets.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/scaling.dart';
import 'package:live_cv_serverpod_flutter/helpers/sizes/spacers.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';
import 'package:live_cv_serverpod_flutter/views/dialog/params.dart';
import 'package:live_cv_serverpod_flutter/widgets/description_container.dart';
import 'package:live_cv_serverpod_flutter/widgets/image_description_container.dart';

class ReadMoreContainer extends StatelessWidget {
  final String? header;
  final String? subheader;
  final List<String?>? paragraph;
  final String? path;
  final DescriptionType type;
  final bool isAsset;
  final int maxCharacters;
  final Color? backgroundColor;
  final Color? textColor;
  final bool readMoreDialog;
  const ReadMoreContainer({
    super.key,
    required this.maxCharacters,
    required this.type,
    this.textColor,
    this.backgroundColor,
    this.readMoreDialog = false,
    this.header,
    this.subheader,
    this.paragraph,
    this.path,
    this.isAsset = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor,
      padding: AppEdgeInsets.all(Sizes.l),
      child: Column(
        children: [
          Sizes.m.spacer(),
          if (header != null)
            Text(
              header!,
              style: AppTheme.currentTheme.textTheme.titleLarge?.copyWith(color: textColor),
            ),
          Sizes.m.spacer(),
          if (subheader != null)
            Text(
              subheader!,
              style: AppTheme.currentTheme.textTheme.titleSmall?.copyWith(color: textColor),
            ),
          Sizes.m.spacer(),
          if (paragraph != null)
            readMoreDialog
                ? ReadMoreTextDialog(
                    header: header,
                    subheader: subheader,
                    paragraph: paragraph!,
                    path: path,
                    type: type,
                    isAsset: isAsset,
                    maxCharacterCount: maxCharacters,
                  )
                : ReadMoreText(
                    text: paragraph!.concatenateWithNewline(),
                    maxCharacterCount: maxCharacters,
                    textColor: textColor,
                  ),
          Sizes.m.spacer(),
        ],
      ),
    );
  }
}

class ReadMoreText extends StatefulWidget {
  final String text;
  final int maxCharacterCount;
  final Color? textColor;

  const ReadMoreText({
    super.key,
    required this.text,
    required this.maxCharacterCount,
    this.textColor,
  });

  @override
  ReadMoreTextState createState() => ReadMoreTextState();
}

class ReadMoreTextState extends State<ReadMoreText> {
  bool isExpanded = false;
  String get displayText => (widget.text.length <= widget.maxCharacterCount
      ? widget.text
      : "${widget.text.substring(
          0,
          widget.text.lastIndexOf(' ', widget.maxCharacterCount),
        )}...");
  String get expandedText => widget.text;

  @override
  Widget build(BuildContext context) {
    print("Max Count: ${widget.maxCharacterCount}  => ${widget.text.length}");

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            isExpanded ? expandedText : displayText,
            style: AppTheme.currentTheme.textTheme.bodyMedium?.copyWith(color: widget.textColor),
          ),
          if (widget.text.length > widget.maxCharacterCount) Sizes.xl.spacer(),
          if (widget.text.length > widget.maxCharacterCount)
            Button.textPill(
              color: Colors.blueGrey[700],
              horizontalScaling: const ScalingStyle.shrink(),
              buttonText: isExpanded ? 'Read Less' : 'Read More',
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
            )
        ],
      ),
    );
  }
}

class ReadMoreTextDialog extends StatelessWidget {
  final int maxCharacterCount;
  final String? header;
  final String? subheader;
  final List<String?> paragraph;
  final String? path;
  final DescriptionType type;
  final Color? textColor;
  final bool isAsset;
  const ReadMoreTextDialog({
    super.key,
    required this.maxCharacterCount,
    required this.type,
    this.textColor,
    this.header,
    this.subheader,
    required this.paragraph,
    this.path,
    required this.isAsset,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _getDisplayText(),
            style: AppTheme.currentTheme.textTheme.bodyMedium,
          ),
          if (paragraph.concatenateWithNewline().length > maxCharacterCount) Sizes.xl.spacer(),
          if (paragraph.concatenateWithNewline().length > maxCharacterCount)
            Button.textPill(
              color: Colors.blueGrey[700],
              horizontalScaling: const ScalingStyle.shrink(),
              buttonText: 'Read More',
              onTap: () {
                Managers.navigationService.showDialogBase(
                    view: Column(
                      children: [
                        if (path == null)
                          DescriptionContainer(
                            description: Description(
                              type: type.name,
                              header: header,
                              subheader: subheader,
                              paragraph: paragraph,
                            ),
                          ),
                        if (path != null && isAsset)
                          ImageDescriptionContainer.asset(
                              textColor: textColor,
                              imageDescription: ImageDescription(
                                type: type.name,
                                path: path,
                                subheader: subheader,
                                paragraph: paragraph.concatenateWithNewline().trim(),
                              ),
                              maxDescriptionCharacters: paragraph.concatenateWithNewline().length),
                        if (path != null && !isAsset)
                          ImageDescriptionContainer.network(
                              textColor: textColor,
                              imageDescription: ImageDescription(
                                type: type.name,
                                path: path,
                                subheader: subheader,
                                paragraph: paragraph.concatenateWithNewline().trim(),
                              ),
                              maxDescriptionCharacters: paragraph.concatenateWithNewline().length),
                        Button.textPill(
                          color: Colors.blueGrey[700],
                          horizontalScaling: const ScalingStyle.shrink(),
                          buttonText: 'Close',
                          onTap: () => Managers.navigationService.pop(),
                        ),
                        if (paragraph.concatenateWithNewline().length > maxCharacterCount) Sizes.xl.spacer(),
                      ],
                    ),
                    params: DialogParams("readMore"));
              },
            ),
        ],
      ),
    );
  }

  String _getDisplayText() {
    final String text = paragraph.concatenateWithNewline();
    return (text.length <= maxCharacterCount ? text : "${text.substring(0, text.lastIndexOf(' ', maxCharacterCount))}...");
  }
}
