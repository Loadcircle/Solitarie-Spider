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
