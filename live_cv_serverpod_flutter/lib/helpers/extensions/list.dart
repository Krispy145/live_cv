extension ListExtension<E> on List<E> {
  E? get safeFirst => isNotEmpty ? first : null;

  E? safeFirstWhere(bool Function(E) condition) {
    final index = indexWhere(condition);
    return (index == -1) ? null : this[index];
  }

  bool containsWhere(bool Function(E) closure) {
    try {
      final contains = any(closure);
      return contains;
    } catch (e) {
      return false;
    }
  }

  void insertBetween(E divider) {
    if (length < 2) return;
    List<int>.generate(length, (i) => i * 2 + 1)
      ..removeLast()
      ..forEach((index) => insert(index, divider));
  }

  void changeElementPosition(int oldIndex, int newIndex) {
    E element = removeAt(oldIndex);

    if (newIndex > oldIndex) newIndex--;

    if (newIndex >= length) {
      add(element);
    } else {
      insert(newIndex, element);
    }
  }
}

extension ConcatenateStrings on List<String?> {
  String concatenateWithNewline() {
    return map((str) => '$str\n\n').join();
  }
}
