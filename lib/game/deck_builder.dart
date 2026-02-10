import '../core/enums/suit.dart';
import '../core/enums/rank.dart';
import '../core/enums/difficulty.dart';
import '../core/constants/game_constants.dart';
import '../models/playing_card.dart';

class DeckBuilder {
  DeckBuilder._();

  static List<PlayingCard> buildDeck(Difficulty difficulty) {
    final suits = _suitsForDifficulty(difficulty);
    final cards = <PlayingCard>[];

    // Build 104 cards using the selected suits
    final setsNeeded = GameConstants.totalCards ~/ (suits.length * GameConstants.cardsPerSuit);

    for (var deckIndex = 0; deckIndex < setsNeeded; deckIndex++) {
      for (final suit in suits) {
        for (final rank in Rank.values) {
          cards.add(PlayingCard(
            suit: suit,
            rank: rank,
            id: '${suit.name}_${rank.name}_$deckIndex',
          ));
        }
      }
    }

    cards.shuffle();
    return cards;
  }

  static List<Suit> _suitsForDifficulty(Difficulty difficulty) {
    switch (difficulty) {
      case Difficulty.oneSuit:
        return [Suit.spades];
      case Difficulty.twoSuits:
        return [Suit.spades, Suit.hearts];
      case Difficulty.fourSuits:
        return Suit.values;
    }
  }
}
