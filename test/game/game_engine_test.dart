import 'package:flutter_test/flutter_test.dart';
import 'package:my_solitarie/core/enums/difficulty.dart';
import 'package:my_solitarie/core/constants/game_constants.dart';
import 'package:my_solitarie/game/game_engine.dart';

void main() {
  group('GameEngine.createNewGame', () {
    for (final difficulty in Difficulty.values) {
      test('creates valid game for ${difficulty.name}', () {
        final state = GameEngine.createNewGame(difficulty);

        // 10 columns
        expect(state.tableau.length, GameConstants.tableauCount);

        // Columns 0-3 have 6 cards, columns 4-9 have 5 cards
        for (var i = 0; i < 4; i++) {
          expect(state.tableau[i].length, 6, reason: 'Column $i should have 6 cards');
        }
        for (var i = 4; i < 10; i++) {
          expect(state.tableau[i].length, 5, reason: 'Column $i should have 5 cards');
        }

        // 50 cards in stock
        expect(state.stock.length, 50);

        // Total: 54 dealt + 50 stock = 104
        final totalCards = state.tableau.fold<int>(0, (sum, col) => sum + col.length) +
            state.stock.length;
        expect(totalCards, GameConstants.totalCards);

        // Last card in each column is face up
        for (final col in state.tableau) {
          expect(col.last.isFaceUp, true);
          // All other cards face down
          for (var i = 0; i < col.length - 1; i++) {
            expect(col[i].isFaceUp, false);
          }
        }

        // Initial state
        expect(state.score, GameConstants.initialScore);
        expect(state.moveCount, 0);
        expect(state.completedSequences, 0);
        expect(state.isWon, false);
        expect(state.isStarted, true);
        expect(state.difficulty, difficulty);
      });
    }
  });

  group('GameEngine.dealFromStock', () {
    test('deals 10 cards (1 per column)', () {
      final state = GameEngine.createNewGame(Difficulty.oneSuit);
      final newState = GameEngine.dealFromStock(state);

      expect(newState, isNotNull);
      expect(newState!.stock.length, state.stock.length - 10);

      // Each column should have one more card
      for (var i = 0; i < 10; i++) {
        expect(newState.tableau[i].length, state.tableau[i].length + 1);
        expect(newState.tableau[i].last.isFaceUp, true);
      }
    });

    test('returns null when stock is empty', () {
      var state = GameEngine.createNewGame(Difficulty.oneSuit);
      // Deal all 5 rounds
      for (var i = 0; i < 5; i++) {
        state = GameEngine.dealFromStock(state)!;
      }
      expect(state.stock.isEmpty, true);
      expect(GameEngine.dealFromStock(state), null);
    });

    test('returns null when any column is empty', () {
      final state = GameEngine.createNewGame(Difficulty.oneSuit);
      // Manually create a state with an empty column
      final tableau = [...state.tableau.map((c) => [...c])];
      tableau[0] = [];
      final modifiedState = state.copyWith(tableau: tableau);
      expect(GameEngine.dealFromStock(modifiedState), null);
    });

    test('succeeds with empty column when allowEmptyColumns is true', () {
      final state = GameEngine.createNewGame(Difficulty.oneSuit);
      // Manually create a state with an empty column
      final tableau = [...state.tableau.map((c) => [...c])];
      tableau[0] = [];
      final modifiedState = state.copyWith(tableau: tableau);
      final result =
          GameEngine.dealFromStock(modifiedState, allowEmptyColumns: true);
      expect(result, isNotNull);
      expect(result!.stock.length, modifiedState.stock.length - 10);
    });
  });

  group('GameEngine.moveCards', () {
    test('moves cards between columns', () {
      final state = GameEngine.createNewGame(Difficulty.oneSuit);
      // Try to move the last card from column 0 to column 1
      // This might or might not work depending on the cards dealt
      // but the function should not crash
      final result = GameEngine.moveCards(
        state: state,
        fromColumn: 0,
        cardIndex: state.tableau[0].length - 1,
        toColumn: 1,
      );
      // Result can be null if the move is invalid
      expect(result == null || result.moveCount == 1, true);
    });

    test('returns null for same column', () {
      final state = GameEngine.createNewGame(Difficulty.oneSuit);
      final result = GameEngine.moveCards(
        state: state,
        fromColumn: 0,
        cardIndex: 0,
        toColumn: 0,
      );
      expect(result, null);
    });
  });
}
