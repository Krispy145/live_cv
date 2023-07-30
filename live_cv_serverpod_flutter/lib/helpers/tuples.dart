class Pair<A, B> {
  final A first;
  final B second;

  const Pair(this.first, this.second);

  @override
  String toString() => 'Pair - 1: $first, 2: $second';

  Pair<A, B> copyWith({
    A? first,
    B? second,
  }) {
    return Pair<A, B>(
      first ?? this.first,
      second ?? this.second,
    );
  }
}

class Triple<A, B, C> {
  final A first;
  final B second;
  final C third;

  const Triple(this.first, this.second, this.third);

  @override
  String toString() => 'Triple - 1: $first, 2: $second, 3: $third';

  Triple<A, B, C> copyWith({
    A? first,
    B? second,
    C? third,
  }) {
    return Triple<A, B, C>(
      first ?? this.first,
      second ?? this.second,
      third ?? this.third,
    );
  }
}
