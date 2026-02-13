import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_result.dart';

class HistoryNotifier extends StateNotifier<List<GameResult>> {
  HistoryNotifier() : super([]);

  void addResult(GameResult result) {
    state = [...state, result];
  }

  void clear() {
    state = [];
  }
}

final historyProvider =
    StateNotifierProvider<HistoryNotifier, List<GameResult>>((ref) {
  return HistoryNotifier();
});

/// Consecutive days (ending today or yesterday) where the player won at least 1 game.
final playStreakProvider = Provider<int>((Ref ref) {
  final List<GameResult> history = ref.watch(historyProvider);

  // Collect unique dates that have at least one win.
  final Set<DateTime> winDays = {};
  for (final GameResult r in history) {
    if (r.isWon) {
      winDays.add(DateTime(r.dateTime.year, r.dateTime.month, r.dateTime.day));
    }
  }

  if (winDays.isEmpty) return 0;

  // Walk backwards from today counting consecutive days with a win.
  DateTime day = DateTime.now();
  day = DateTime(day.year, day.month, day.day);

  // Allow streak to start from today or yesterday (in case they haven't played today yet).
  if (!winDays.contains(day)) {
    day = day.subtract(const Duration(days: 1));
    if (!winDays.contains(day)) return 0;
  }

  int streak = 0;
  while (winDays.contains(day)) {
    streak++;
    day = day.subtract(const Duration(days: 1));
  }

  return streak;
});

final historyByDateProvider = Provider<Map<DateTime, List<GameResult>>>((ref) {
  final history = ref.watch(historyProvider);
  final Map<DateTime, List<GameResult>> grouped = {};

  for (final GameResult result in history) {
    final DateTime key = DateTime(
      result.dateTime.year,
      result.dateTime.month,
      result.dateTime.day,
    );
    grouped.putIfAbsent(key, () => []).add(result);
  }

  return grouped;
});
