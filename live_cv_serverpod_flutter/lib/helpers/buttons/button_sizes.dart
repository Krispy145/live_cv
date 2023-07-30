/// An enum used to specify the button size of a [Button] object.
enum ButtonSizes {
  s,
  m;

  double get height {
    switch (this) {
      case ButtonSizes.s:
        return 24;
      case ButtonSizes.m:
        return 40;
    }
  }

  double get iconSize => 28;
}
