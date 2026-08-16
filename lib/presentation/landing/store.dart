import "package:flutter/animation.dart";
import "package:mobx/mobx.dart";
import "package:scrollable_positioned_list/scrollable_positioned_list.dart";

/// Landing page sections.
enum LandingOption {
  header,
  experience,
  education,
  skills,
  roadmap,
  portfolio,
  contact,
  ;

  /// Options shown in the app bar (contact is handled by the floating menu).
  static List<LandingOption> get appbarOptions => values.where((option) => option != LandingOption.contact).toList();
}

/// Scroll / section state for the landing page.
class LandingStore {
  /// [LandingStore] constructor.
  LandingStore() {
    itemPositionsListener.itemPositions.addListener(_syncCurrentIndex);
  }

  final ItemScrollController itemScrollController = ItemScrollController();
  final ScrollOffsetController scrollOffsetController = ScrollOffsetController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();
  final ScrollOffsetListener scrollOffsetListener = ScrollOffsetListener.create();

  final Observable<int> _currentIndex = Observable(0);

  int get currentIndex => _currentIndex.value;

  bool isCurrentIndex(int index) => currentIndex == index;

  Future<void> scrollToIndex(int index) async {
    _currentIndex.value = index;
    if (!itemScrollController.isAttached) {
      return;
    }
    await itemScrollController.scrollTo(
      index: index,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  void _syncCurrentIndex() {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) {
      return;
    }
    final visible = positions.where((position) => position.itemLeadingEdge < 0.5).toList()
      ..sort((a, b) => b.itemLeadingEdge.compareTo(a.itemLeadingEdge));
    if (visible.isEmpty) {
      return;
    }
    final nextIndex = visible.first.index;
    if (nextIndex != currentIndex) {
      _currentIndex.value = nextIndex;
    }
  }
}
