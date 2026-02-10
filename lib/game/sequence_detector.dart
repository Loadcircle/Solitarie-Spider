import '../core/constants/game_constants.dart';
import '../core/enums/rank.dart';
import '../models/playing_card.dart';

class SequenceDetector {
  SequenceDetector._();

  /// Returns the starting index of a completed K→A same-suit sequence
  /// at the bottom of the column, or null if none found.
  static int? findCompletedSequence(List<PlayingCard> column) {
    if (column.length < GameConstants.cardsPerSuit) return null;

    final startIndex = column.length - GameConstants.cardsPerSuit;

    // Check: must start with King, end with Ace, all same suit, all face up
    final firstCard = column[startIndex];
    if (firstCard.rank != Rank.king) return null;
    if (!firstCard.isFaceUp) return null;

    final suit = firstCard.suit;

    for (var i = startIndex; i < column.length - 1; i++) {
      final current = column[i];
      final next = column[i + 1];

      if (!current.isFaceUp || !next.isFaceUp) return null;
      if (current.suit != suit || next.suit != suit) return null;
      if (current.rank.value != next.rank.value + 1) return null;
    }

    // Verify last card is Ace
    if (column.last.rank != Rank.ace) return null;

    return startIndex;
  }
}
