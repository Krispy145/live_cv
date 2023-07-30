import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/wrappers/scroll_index/controller.dart';
import 'package:live_cv_serverpod_flutter/managers/managers.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollIndexWrapper extends StatelessWidget {
  final int itemsCount;
  final Widget Function(BuildContext context, int index) bodyItemsBuilder;
  ScrollIndexWrapper({super.key, required this.bodyItemsBuilder, required this.itemsCount});

  final ScrollIndexManager manager = Managers.scrollIndex;

  @override
  Widget build(BuildContext context) {
    return ScrollablePositionedList.builder(
      itemCount: itemsCount,
      itemBuilder: bodyItemsBuilder,
      physics: const ClampingScrollPhysics(),
      itemScrollController: manager.scrollController,
      itemPositionsListener: manager.itemPositionsListener,
    );
  }
}
