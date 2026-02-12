import '../models/game_state.dart';
import '../models/playing_card.dart';
import 'move_validator.dart';

class GameOverDetector {
  GameOverDetector._();

  /// Returns true if the game is lost: no useful actions remaining.
  ///
  /// Accounts for:
  /// - Whether stock can actually be dealt (empty columns may block it)
  /// - Whether moves to empty columns are useful (expose face-down cards)
  static bool isGameOver(
    GameState state, {
    bool allowDealWithEmptyColumns = false,
  }) {
    if (state.isWon) return false;

    final tableau = state.tableau;
    final bool hasEmptyColumn = tableau.any((List<PlayingCard> col) => col.isEmpty);

    // Check if the player can deal from stock
    if (state.stock.isNotEmpty) {
      final bool canDeal =
          allowDealWithEmptyColumns || !hasEmptyColumn;
      if (canDeal) return false;
    }

    // Stock is empty or dealing is blocked — check for valid moves
    final bool hasStock = state.stock.isNotEmpty;

    for (var i = 0; i < tableau.length; i++) {
      final column = tableau[i];
      for (var j = 0; j < column.length; j++) {
        if (!column[j].isFaceUp) continue;

        final cards = column.sublist(j);
        if (!MoveValidator.canPickUp(cards)) continue;

        final topCard = cards.first;
        for (var k = 0; k < tableau.length; k++) {
          if (k == i) continue;
          if (!MoveValidator.canDrop(topCard, tableau[k])) continue;

          // Move to non-empty column → always useful
          if (tableau[k].isNotEmpty) return false;

          // Move to empty column — is it useful?
          if (hasStock) {
            // Stock exists but can't deal yet: filling an empty column
            // helps toward enabling a deal
            return false;
          }

          // Stock is empty: only useful if it exposes a face-down card
          final bool exposesHiddenCard =
              j > 0 && !column[j - 1].isFaceUp;
          if (exposesHiddenCard) return false;
        }
      }
    }

    return true;
  }
}
