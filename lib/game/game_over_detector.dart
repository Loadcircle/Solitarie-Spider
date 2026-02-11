import '../models/game_state.dart';
import 'move_validator.dart';

class GameOverDetector {
  GameOverDetector._();

  /// Returns true if the game is lost: no stock remaining and no valid moves.
  static bool isGameOver(GameState state) {
    if (state.isWon) return false;
    if (state.stock.isNotEmpty) return false;

    final tableau = state.tableau;

    for (var i = 0; i < tableau.length; i++) {
      final column = tableau[i];
      for (var j = 0; j < column.length; j++) {
        if (!column[j].isFaceUp) continue;

        final cards = column.sublist(j);
        if (!MoveValidator.canPickUp(cards)) continue;

        final topCard = cards.first;
        for (var k = 0; k < tableau.length; k++) {
          if (k == i) continue;
          if (MoveValidator.canDrop(topCard, tableau[k])) return false;
        }
      }
    }

    return true;
  }
}
