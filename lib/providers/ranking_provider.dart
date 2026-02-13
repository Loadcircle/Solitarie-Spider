import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums/difficulty.dart';
import '../models/difficulty_stats.dart';
import '../models/game_result.dart';
import 'history_provider.dart';

final rankingProvider = Provider<Map<Difficulty, DifficultyStats>>((ref) {
  final history = ref.watch(historyProvider);
  final Map<Difficulty, DifficultyStats> stats = {};

  for (final difficulty in Difficulty.values) {
    final games = history
        .where((GameResult r) => r.difficulty == difficulty)
        .toList();

    if (games.isEmpty) continue;

    final wonGames = games.where((GameResult r) => r.isWon).toList();

    // Fastest time: min time among WON games
    Duration? fastestTime;
    if (wonGames.isNotEmpty) {
      fastestTime = wonGames
          .map((GameResult r) => r.time)
          .reduce((Duration a, Duration b) => a < b ? a : b);
    }

    // Average time: mean of WON games only
    final Duration averageTime;
    if (wonGames.isNotEmpty) {
      final totalMicroseconds = wonGames.fold<int>(
        0,
        (int sum, GameResult r) => sum + r.time.inMicroseconds,
      );
      averageTime = Duration(microseconds: totalMicroseconds ~/ wonGames.length);
    } else {
      averageTime = Duration.zero;
    }

    // Longest win streak: max consecutive wins in chronological order
    final sorted = [...games];
    sorted.sort(
      (GameResult a, GameResult b) => a.dateTime.compareTo(b.dateTime),
    );
    int longestStreak = 0;
    int currentStreak = 0;
    for (final GameResult game in sorted) {
      if (game.isWon) {
        currentStreak++;
        if (currentStreak > longestStreak) {
          longestStreak = currentStreak;
        }
      } else {
        currentStreak = 0;
      }
    }

    // Best score: max score
    final bestScore = games
        .map((GameResult r) => r.score)
        .reduce((int a, int b) => a > b ? a : b);

    stats[difficulty] = DifficultyStats(
      fastestTime: fastestTime,
      averageTime: averageTime,
      longestWinStreak: longestStreak,
      bestScore: bestScore,
      totalGames: games.length,
    );
  }

  return stats;
});
