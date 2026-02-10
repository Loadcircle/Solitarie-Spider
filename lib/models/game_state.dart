import '../core/enums/difficulty.dart';
import 'playing_card.dart';

class GameState {
  final List<List<PlayingCard>> tableau;
  final List<PlayingCard> stock;
  final int completedSequences;
  final int score;
  final int moveCount;
  final Duration elapsed;
  final Difficulty difficulty;
  final bool isWon;
  final bool isStarted;

  const GameState({
    required this.tableau,
    required this.stock,
    this.completedSequences = 0,
    this.score = 500,
    this.moveCount = 0,
    this.elapsed = Duration.zero,
    required this.difficulty,
    this.isWon = false,
    this.isStarted = false,
  });

  GameState copyWith({
    List<List<PlayingCard>>? tableau,
    List<PlayingCard>? stock,
    int? completedSequences,
    int? score,
    int? moveCount,
    Duration? elapsed,
    Difficulty? difficulty,
    bool? isWon,
    bool? isStarted,
  }) {
    return GameState(
      tableau: tableau ?? this.tableau,
      stock: stock ?? this.stock,
      completedSequences: completedSequences ?? this.completedSequences,
      score: score ?? this.score,
      moveCount: moveCount ?? this.moveCount,
      elapsed: elapsed ?? this.elapsed,
      difficulty: difficulty ?? this.difficulty,
      isWon: isWon ?? this.isWon,
      isStarted: isStarted ?? this.isStarted,
    );
  }

  int get stockDealsRemaining => stock.length ~/ 10;
}
