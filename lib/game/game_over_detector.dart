import 'package:flutter/foundation.dart';
import '../models/game_state.dart';
import '../models/playing_card.dart';
import 'move_validator.dart';

class GameOverDetector {
  GameOverDetector._();

  /// Returns true when at least one valid move exists on the tableau.
  static bool hasAnyValidMove(GameState state) {
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
          if (!MoveValidator.canDrop(topCard, tableau[k])) continue;
          return true;
        }
      }
    }
    return false;
  }

  /// Returns true if the game is lost: no useful actions remaining.
  static bool isGameOver(
    GameState state, {
    bool allowDealWithEmptyColumns = false,
  }) {
    if (state.isWon) return false;

    final tableau = state.tableau;
    final bool hasEmptyColumn =
        tableau.any((List<PlayingCard> col) => col.isEmpty);

    // If stock is available, the player can always deal:
    // either columns are filled, or the setting allows it, or
    // no move can fill empty columns (forced deal as fallback).
    if (state.stock.isNotEmpty) {
      final bool canDeal = allowDealWithEmptyColumns || !hasEmptyColumn;
      if (canDeal) return false;

      // Stock blocked by empty columns — but deal will be forced
      // if no move can fill them, so this is never game over.
      return false;
    }

    // ── No stock left — check for moves that make real progress ──
    for (var i = 0; i < tableau.length; i++) {
      final column = tableau[i];
      for (var j = 0; j < column.length; j++) {
        if (!column[j].isFaceUp) continue;

        final cards = column.sublist(j);
        if (!MoveValidator.canPickUp(cards)) continue;

        final topCard = cards.first;
        final bool exposesHidden = j > 0 && !column[j - 1].isFaceUp;
        final bool emptiesColumn = j == 0;

        for (var k = 0; k < tableau.length; k++) {
          if (k == i) continue;
          if (!MoveValidator.canDrop(topCard, tableau[k])) continue;

          // 1. Exposes a face-down card → always useful
          if (exposesHidden) return false;

          // 2. Empties the source column → useful (reorganization)
          if (emptiesColumn && tableau[k].isNotEmpty) return false;

          // 3. Same-suit consolidation that IMPROVES the board
          if (tableau[k].isNotEmpty) {
            final targetTop = tableau[k].last;
            if (targetTop.suit == topCard.suit) {
              // Check if this card was already same-suit connected below it
              // in the source column. If so, moving is just relocating.
              final bool alreadyConnected = j > 0 &&
                  column[j - 1].isFaceUp &&
                  column[j - 1].suit == topCard.suit &&
                  column[j - 1].rank.value == topCard.rank.value + 1;

              if (!alreadyConnected) {
                // TODO: remove debug print
                debugPrint('[GameOver] => NOT over: ${_seqDesc(cards)} '
                    'col$i -> col$k IMPROVES same-suit sequence '
                    '(onto ${_cardDesc(targetTop)})');
                return false;
              }
            }
          }
        }
      }
    }

    return true;
  }

  static String _cardDesc(PlayingCard c) =>
      '${c.rank.name}${c.suit.name[0]}';

  static String _seqDesc(List<PlayingCard> cards) {
    final top = cards.first;
    final bottom = cards.last;
    if (cards.length == 1) return _cardDesc(top);
    return '${_cardDesc(top)}..${_cardDesc(bottom)}(${cards.length})';
  }
}
