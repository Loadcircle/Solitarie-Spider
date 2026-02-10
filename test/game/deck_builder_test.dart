import 'package:flutter_test/flutter_test.dart';
import 'package:my_solitarie/core/enums/difficulty.dart';
import 'package:my_solitarie/core/constants/game_constants.dart';
import 'package:my_solitarie/game/deck_builder.dart';

void main() {
  group('DeckBuilder', () {
    test('builds 104 cards for 1-suit difficulty', () {
      final deck = DeckBuilder.buildDeck(Difficulty.oneSuit);
      expect(deck.length, GameConstants.totalCards);
    });

    test('builds 104 cards for 2-suit difficulty', () {
      final deck = DeckBuilder.buildDeck(Difficulty.twoSuits);
      expect(deck.length, GameConstants.totalCards);
    });

    test('builds 104 cards for 4-suit difficulty', () {
      final deck = DeckBuilder.buildDeck(Difficulty.fourSuits);
      expect(deck.length, GameConstants.totalCards);
    });

    test('all cards have unique IDs', () {
      final deck = DeckBuilder.buildDeck(Difficulty.fourSuits);
      final ids = deck.map((c) => c.id).toSet();
      expect(ids.length, deck.length);
    });

    test('1-suit deck contains only spades', () {
      final deck = DeckBuilder.buildDeck(Difficulty.oneSuit);
      for (final card in deck) {
        expect(card.suit.name, 'spades');
      }
    });

    test('cards start face down', () {
      final deck = DeckBuilder.buildDeck(Difficulty.oneSuit);
      for (final card in deck) {
        expect(card.isFaceUp, false);
      }
    });
  });
}
