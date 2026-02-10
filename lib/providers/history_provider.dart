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
