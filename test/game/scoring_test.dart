import 'package:flutter_test/flutter_test.dart';
import 'package:my_solitarie/game/scoring.dart';

void main() {
  group('Scoring', () {
    test('initial score is 500 with no moves', () {
      expect(
        Scoring.calculateScore(
          moveCount: 0,
          completedSequences: 0,
          isWon: false,
        ),
        500,
      );
    });

    test('each move costs 1 point', () {
      expect(
        Scoring.calculateScore(
          moveCount: 10,
          completedSequences: 0,
          isWon: false,
        ),
        490,
      );
    });

    test('each sequence adds 100 points', () {
      expect(
        Scoring.calculateScore(
          moveCount: 0,
          completedSequences: 3,
          isWon: false,
        ),
        800,
      );
    });

    test('win adds 500 bonus', () {
      expect(
        Scoring.calculateScore(
          moveCount: 100,
          completedSequences: 8,
          isWon: true,
        ),
        500 - 100 + 800 + 500, // 1700
      );
    });
  });
}
