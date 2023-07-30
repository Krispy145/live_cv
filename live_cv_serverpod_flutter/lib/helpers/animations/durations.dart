enum Durations {
  zero,
  xxs,
  xs,
  s,
  m,
  l,
  xl,
  xxl,
  xxxl;

  Duration get duration {
    switch (this) {
      case Durations.zero:
        return Duration.zero;
      case Durations.xxs:
        return const Duration(milliseconds: 100);
      case Durations.xs:
        return const Duration(milliseconds: 250);
      case Durations.s:
        return const Duration(milliseconds: 500);
      case Durations.m:
        return const Duration(milliseconds: 750);
      case Durations.l:
        return const Duration(milliseconds: 1000);
      case Durations.xl:
        return const Duration(milliseconds: 2000);
      case Durations.xxl:
        return const Duration(milliseconds: 3000);
      case Durations.xxxl:
        return const Duration(milliseconds: 5000);
    }
  }

  Future<void> wait() => Future.delayed(duration);
}
