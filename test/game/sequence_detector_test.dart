import 'package:flutter_test/flutter_test.dart';
import 'package:my_solitarie/core/enums/suit.dart';
import 'package:my_solitarie/core/enums/rank.dart';
import 'package:my_solitarie/models/playing_card.dart';
import 'package:my_solitarie/game/sequence_detector.dart';

void main() {
  group('SequenceDetector', () {
    test('detects K->A same-suit sequence at bottom of column', () {
      final column = [
        for (final rank in Rank.values.reversed)
          PlayingCard(
            suit: Suit.spades,
            rank: rank,
            isFaceUp: true,
            id: 'test_${rank.name}',
          ),
      ];
      expect(column.length, 13);
      expect(SequenceDetector.findCompletedSequence(column), 0);
    });

    test('returns null for incomplete sequence', () {
      final column = [
        PlayingCard(suit: Suit.spades, rank: Rank.king, isFaceUp: true, id: 'k'),
        PlayingCard(suit: Suit.spades, rank: Rank.queen, isFaceUp: true, id: 'q'),
      ];
      expect(SequenceDetector.findCompletedSequence(column), null);
    });

    test('returns null for mixed-suit sequence', () {
      final column = <PlayingCard>[];
      for (var i = 0; i < 13; i++) {
        final rank = Rank.values[12 - i]; // K, Q, J, ... A
        column.add(PlayingCard(
          suit: i == 6 ? Suit.hearts : Suit.spades,
          rank: rank,
          isFaceUp: true,
          id: 'test_$i',
        ));
      }
      expect(SequenceDetector.findCompletedSequence(column), null);
    });

    test('detects sequence with face-down cards above', () {
      final column = <PlayingCard>[
        PlayingCard(suit: Suit.spades, rank: Rank.ace, isFaceUp: false, id: 'down_0'),
        PlayingCard(suit: Suit.spades, rank: Rank.two, isFaceUp: false, id: 'down_1'),
      ];
      for (final rank in Rank.values.reversed) {
        column.add(PlayingCard(
          suit: Suit.spades,
          rank: rank,
          isFaceUp: true,
          id: 'test_${rank.name}',
        ));
      }
      expect(SequenceDetector.findCompletedSequence(column), 2);
    });

    test('returns null for empty column', () {
      expect(SequenceDetector.findCompletedSequence([]), null);
    });
  });
}
