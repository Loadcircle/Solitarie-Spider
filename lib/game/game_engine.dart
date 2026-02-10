import '../core/enums/difficulty.dart';
import '../core/constants/game_constants.dart';
import '../models/game_state.dart';
import '../models/playing_card.dart';
import 'deck_builder.dart';
import 'move_validator.dart';
import 'sequence_detector.dart';

class GameEngine {
  GameEngine._();

  static GameState createNewGame(Difficulty difficulty) {
    final deck = DeckBuilder.buildDeck(difficulty);
    final tableau = <List<PlayingCard>>[];
    var cardIndex = 0;

    for (var col = 0; col < GameConstants.tableauCount; col++) {
      final cardCount = col < GameConstants.columnsWithSixCards
          ? GameConstants.cardsInLargeColumn
          : GameConstants.cardsInSmallColumn;

      final column = <PlayingCard>[];
      for (var i = 0; i < cardCount; i++) {
        final isLastCard = i == cardCount - 1;
        column.add(deck[cardIndex].copyWith(isFaceUp: isLastCard));
        cardIndex++;
      }
      tableau.add(column);
    }

    final stock = deck.sublist(cardIndex);

    return GameState(
      tableau: tableau,
      stock: stock,
      score: GameConstants.initialScore,
      difficulty: difficulty,
      isStarted: true,
    );
  }

  static GameState? moveCards({
    required GameState state,
    required int fromColumn,
    required int cardIndex,
    required int toColumn,
  }) {
    if (fromColumn == toColumn) return null;

    final sourceColumn = state.tableau[fromColumn];
    if (cardIndex < 0 || cardIndex >= sourceColumn.length) return null;

    final cardsToMove = sourceColumn.sublist(cardIndex);

    if (!MoveValidator.canPickUp(cardsToMove)) return null;
    if (!MoveValidator.canDrop(cardsToMove.first, state.tableau[toColumn])) {
      return null;
    }

    // Perform the move
    final newTableau = [
      for (var i = 0; i < state.tableau.length; i++)
        if (i == fromColumn)
          sourceColumn.sublist(0, cardIndex)
        else if (i == toColumn)
          [...state.tableau[i], ...cardsToMove]
        else
          [...state.tableau[i]],
    ];

    // Flip newly exposed card in source column
    if (newTableau[fromColumn].isNotEmpty &&
        !newTableau[fromColumn].last.isFaceUp) {
      newTableau[fromColumn] = [
        ...newTableau[fromColumn].sublist(0, newTableau[fromColumn].length - 1),
        newTableau[fromColumn].last.copyWith(isFaceUp: true),
      ];
    }

    var newState = state.copyWith(
      tableau: newTableau,
      moveCount: state.moveCount + 1,
      score: state.score - GameConstants.movePointPenalty,
    );

    // Check for completed sequences
    newState = _checkAndRemoveSequences(newState);

    return newState;
  }

  static GameState? dealFromStock(GameState state) {
    if (state.stock.isEmpty) return null;

    // All columns must have at least one card
    for (final column in state.tableau) {
      if (column.isEmpty) return null;
    }

    final cardsToDealt = state.stock
        .take(GameConstants.cardsPerDeal)
        .toList();

    final newTableau = [
      for (var i = 0; i < state.tableau.length; i++)
        [
          ...state.tableau[i],
          cardsToDealt[i].copyWith(isFaceUp: true),
        ],
    ];

    final remainingStock =
        state.stock.sublist(GameConstants.cardsPerDeal);

    var newState = state.copyWith(
      tableau: newTableau,
      stock: remainingStock,
    );

    // Check for completed sequences after dealing
    newState = _checkAndRemoveSequences(newState);

    return newState;
  }

  static GameState _checkAndRemoveSequences(GameState state) {
    var currentState = state;
    var found = true;

    while (found) {
      found = false;
      for (var col = 0; col < currentState.tableau.length; col++) {
        final column = currentState.tableau[col];
        final sequenceStart = SequenceDetector.findCompletedSequence(column);
        if (sequenceStart != null) {
          found = true;

          final newColumn = column.sublist(0, sequenceStart);
          final newTableau = [
            for (var i = 0; i < currentState.tableau.length; i++)
              if (i == col)
                newColumn
              else
                [...currentState.tableau[i]],
          ];

          // Flip newly exposed card
          if (newTableau[col].isNotEmpty &&
              !newTableau[col].last.isFaceUp) {
            newTableau[col] = [
              ...newTableau[col].sublist(0, newTableau[col].length - 1),
              newTableau[col].last.copyWith(isFaceUp: true),
            ];
          }

          final newCompleted = currentState.completedSequences + 1;
          final isWon =
              newCompleted >= GameConstants.completedSequencesNeeded;

          currentState = currentState.copyWith(
            tableau: newTableau,
            completedSequences: newCompleted,
            score: currentState.score +
                GameConstants.sequenceBonus +
                (isWon ? GameConstants.winBonus : 0),
            isWon: isWon,
          );
          break; // Restart scanning after removal
        }
      }
    }

    return currentState;
  }
}
