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

  group('MoveValidator.findBestTarget', () {
    test('finds non-empty column over empty column', () {
      // Column 0: has a 5 of spades (card to move)
      // Column 1: has a 6 of hearts (valid non-empty target)
      // Column 2: empty (valid but less preferred)
      final tableau = <List<PlayingCard>>[
        [PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 't_0')],
        [PlayingCard(suit: Suit.hearts, rank: Rank.six, isFaceUp: true, id: 't_1')],
        [],
      ];
      final result = MoveValidator.findBestTarget(
        tableau: tableau,
        fromColumn: 0,
        cardIndex: 0,
      );
      expect(result, 1);
    });

    test('returns empty column when no non-empty target exists', () {
      // Column 0: has a 5 of spades
      // Column 1: has a 3 of hearts (not valid drop)
      // Column 2: empty
      final tableau = <List<PlayingCard>>[
        [PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 't_0')],
        [PlayingCard(suit: Suit.hearts, rank: Rank.three, isFaceUp: true, id: 't_1')],
        [],
      ];
      final result = MoveValidator.findBestTarget(
        tableau: tableau,
        fromColumn: 0,
        cardIndex: 0,
      );
      expect(result, 2);
    });

    test('returns null when no valid target exists', () {
      // Column 0: has a 5 of spades
      // Column 1: has a 3 of hearts (not valid drop)
      final tableau = <List<PlayingCard>>[
        [PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 't_0')],
        [PlayingCard(suit: Suit.hearts, rank: Rank.three, isFaceUp: true, id: 't_1')],
      ];
      final result = MoveValidator.findBestTarget(
        tableau: tableau,
        fromColumn: 0,
        cardIndex: 0,
      );
      expect(result, null);
    });

    test('returns null when cards cannot be picked up', () {
      // Column with mixed suits (can't pick up)
      final tableau = <List<PlayingCard>>[
        [
          PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 't_0'),
          PlayingCard(suit: Suit.hearts, rank: Rank.four, isFaceUp: true, id: 't_1'),
        ],
        [PlayingCard(suit: Suit.spades, rank: Rank.six, isFaceUp: true, id: 't_2')],
      ];
      final result = MoveValidator.findBestTarget(
        tableau: tableau,
        fromColumn: 0,
        cardIndex: 0,
      );
      expect(result, null);
    });

    test('prefers nearest non-empty column by distance', () {
      // Column 0: card to move (5 of spades)
      // Column 1: has 6 of hearts (valid, distance 1)
      // Column 2: empty
      // Column 3: has 6 of spades (valid, distance 3)
      final tableau = <List<PlayingCard>>[
        [PlayingCard(suit: Suit.spades, rank: Rank.five, isFaceUp: true, id: 't_0')],
        [PlayingCard(suit: Suit.hearts, rank: Rank.six, isFaceUp: true, id: 't_1')],
        [],
        [PlayingCard(suit: Suit.spades, rank: Rank.six, isFaceUp: true, id: 't_3')],
      ];
      final result = MoveValidator.findBestTarget(
        tableau: tableau,
        fromColumn: 0,
        cardIndex: 0,
      );
      expect(result, 1);
    });
  });
}
