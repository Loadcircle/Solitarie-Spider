enum Suit {
  spades('♠', 'Spades'),
  hearts('♥', 'Hearts'),
  diamonds('♦', 'Diamonds'),
  clubs('♣', 'Clubs');

  const Suit(this.symbol, this.displayName);

  final String symbol;
  final String displayName;

  bool get isRed => this == hearts || this == diamonds;
  bool get isBlack => this == spades || this == clubs;
}
