import '../core/enums/difficulty.dart';

class GameResult {
  final DateTime dateTime;
  final Difficulty difficulty;
  final int score;
  final Duration time;
  final int moves;
  final bool isWon;

  const GameResult({
    required this.dateTime,
    required this.difficulty,
    required this.score,
    required this.time,
    required this.moves,
    required this.isWon,
  });
}
