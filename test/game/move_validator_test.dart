import 'package:flutter_test/flutter_test.dart';
import 'package:my_solitarie/core/enums/suit.dart';
import 'package:my_solitarie/core/enums/rank.dart';
import 'package:my_solitarie/models/playing_card.dart';
import 'package:my_solitarie/game/move_validator.dart';

void main() {
  group('MoveValidator.canPickUp', () {
    test('allows single face-up card', () {
      final cards = [
        PlayingCard(suit: Suit.spades, rank: Rank.king, isFaceUp: true, id: 'test_0'),
      ];
      expect(MoveValidator.canPickUp(cards), true);
    });

    test('allows same-suit descending sequence', () {
      final cards = [
        PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 'test_0'),
        PlayingCard(suit: Suit.spades, rank: Rank.four, isFaceUp: true, id: 'test_1'),
        PlayingCard(suit: Suit.spades, rank: Rank.three, isFaceUp: true, id: 'test_2'),
      ];
      expect(MoveValidator.canPickUp(cards), true);
    });

    test('rejects mixed suit sequence', () {
      final cards = [
        PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 'test_0'),
        PlayingCard(suit: Suit.hearts, rank: Rank.four, isFaceUp: true, id: 'test_1'),
      ];
      expect(MoveValidator.canPickUp(cards), false);
    });

    test('rejects non-descending sequence', () {
      final cards = [
        PlayingCard(suit: Suit.spades, rank: Rank.three, isFaceUp: true, id: 'test_0'),
        PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 'test_1'),
      ];
      expect(MoveValidator.canPickUp(cards), false);
    });

    test('rejects face-down cards', () {
      final cards = [
        PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: false, id: 'test_0'),
      ];
      expect(MoveValidator.canPickUp(cards), false);
    });

    test('rejects empty list', () {
      expect(MoveValidator.canPickUp([]), false);
    });
  });

  group('MoveValidator.canDrop', () {
    test('allows drop on empty column', () {
      final card = PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 'test_0');
      expect(MoveValidator.canDrop(card, []), true);
    });

    test('allows drop when target is one rank higher', () {
      final card = PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 'test_0');
      final target = [
        PlayingCard(suit: Suit.hearts, rank: Rank.six, isFaceUp: true, id: 'test_1'),
      ];
      expect(MoveValidator.canDrop(card, target), true);
    });

    test('rejects drop when target is not one rank higher', () {
      final card = PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 'test_0');
      final target = [
        PlayingCard(suit: Suit.hearts, rank: Rank.eight, isFaceUp: true, id: 'test_1'),
      ];
      expect(MoveValidator.canDrop(card, target), false);
    });

    test('allows any suit for drop (differs from pickup)', () {
      final card = PlayingCard(suit: Suit.hearts, rank: Rank.five, isFaceUp: true, id: 'test_0');
      final target = [
        PlayingCard(suit: Suit.spades, rank: Rank.six, isFaceUp: true, id: 'test_1'),
      ];
      expect(MoveValidator.canDrop(card, target), true);
    });
  });
}
