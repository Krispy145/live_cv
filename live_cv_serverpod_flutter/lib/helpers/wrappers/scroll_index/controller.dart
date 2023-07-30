// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:live_cv_serverpod_flutter/helpers/durations.dart';
import 'package:live_cv_serverpod_flutter/helpers/buttons/import.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollIndexManager extends ChangeNotifier {
  ItemScrollController scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  int currentIndex = 0;

  ScrollIndexManager();

  void setIndex(int index) {
    currentIndex = index;
    scrollController.scrollTo(index: index, duration: Durations.m.duration);
    notifyListeners();
  }
}

class ScrollIndexButton {
  final Button button;
  final int index;
  ScrollIndexButton({
    required this.button,
    required this.index,
  });
}
