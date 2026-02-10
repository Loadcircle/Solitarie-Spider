enum Difficulty {
  oneSuit(1),
  twoSuits(2),
  fourSuits(4);

  const Difficulty(this.suitCount);

  final int suitCount;
}
