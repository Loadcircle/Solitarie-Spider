class GameConstants {
  GameConstants._();

  static const int tableauCount = 10;
  static const int totalCards = 104;
  static const int totalDecks = 2;
  static const int cardsPerSuit = 13;
  static const int completedSequencesNeeded = 8;
  static const int stockDeals = 5;
  static const int cardsPerDeal = 10;

  // Initial deal: columns 1-4 get 6 cards, columns 5-10 get 5 cards
  static const int columnsWithSixCards = 4;
  static const int cardsInLargeColumn = 6;
  static const int cardsInSmallColumn = 5;

  // Scoring
  static const int initialScore = 500;
  static const int movePointPenalty = 1;
  static const int sequenceBonus = 100;
  static const int winBonus = 500;
}
