import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/game_result.dart';
import 'history_provider.dart';

final rankingProvider = Provider<List<GameResult>>((ref) {
  final history = ref.watch(historyProvider);
  final sorted = [...history];
  sorted.sort((a, b) => b.score.compareTo(a.score));
  return sorted;
});
