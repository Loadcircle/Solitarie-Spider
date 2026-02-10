import '../models/playing_card.dart';

class MoveValidator {
  MoveValidator._();

  /// Check if a sequence of cards can be picked up.
  /// All cards must be face-up, same suit, and in descending rank order.
  static bool canPickUp(List<PlayingCard> cards) {
    if (cards.isEmpty) return false;
    if (!cards.first.isFaceUp) return false;

    for (var i = 0; i < cards.length - 1; i++) {
      if (!cards[i].isFaceUp || !cards[i + 1].isFaceUp) return false;
      if (cards[i].suit != cards[i + 1].suit) return false;
      if (cards[i].rank.value != cards[i + 1].rank.value + 1) return false;
    }

    return true;
  }

  /// Check if the top card of the dragged stack can be dropped on a column.
  /// Target must be empty OR the bottom card of the target column must be
  /// one rank higher than the top card being dropped (any suit).
  static bool canDrop(PlayingCard topCard, List<PlayingCard> targetColumn) {
    if (targetColumn.isEmpty) return true;

    final targetTop = targetColumn.last;
    return targetTop.rank.value == topCard.rank.value + 1;
  }
}
