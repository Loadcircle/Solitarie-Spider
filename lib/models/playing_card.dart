import '../core/enums/suit.dart';
import '../core/enums/rank.dart';

class PlayingCard {
  final Suit suit;
  final Rank rank;
  final bool isFaceUp;
  final String id;

  const PlayingCard({
    required this.suit,
    required this.rank,
    this.isFaceUp = false,
    required this.id,
  });

  PlayingCard copyWith({
    Suit? suit,
    Rank? rank,
    bool? isFaceUp,
    String? id,
  }) {
    return PlayingCard(
      suit: suit ?? this.suit,
      rank: rank ?? this.rank,
      isFaceUp: isFaceUp ?? this.isFaceUp,
      id: id ?? this.id,
    );
  }

  String get display => '${rank.symbol}${suit.symbol}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayingCard &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'PlayingCard($display, ${isFaceUp ? "up" : "down"}, $id)';
}
