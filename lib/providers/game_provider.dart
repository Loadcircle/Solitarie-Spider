import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums/difficulty.dart';
import '../models/game_state.dart';
import '../game/game_engine.dart';

class GameNotifier extends StateNotifier<GameState?> {
  GameNotifier() : super(null);

  void startNewGame(Difficulty difficulty) {
    state = GameEngine.createNewGame(difficulty);
  }

  void moveCards({
    required int fromColumn,
    required int cardIndex,
    required int toColumn,
  }) {
    if (state == null) return;
    final newState = GameEngine.moveCards(
      state: state!,
      fromColumn: fromColumn,
      cardIndex: cardIndex,
      toColumn: toColumn,
    );
    if (newState != null) {
      state = newState;
    }
  }

  void dealFromStock({bool allowEmptyColumns = false}) {
    if (state == null) return;
    final newState = GameEngine.dealFromStock(
      state!,
      allowEmptyColumns: allowEmptyColumns,
    );
    if (newState != null) {
      state = newState;
    }
  }

  void updateElapsed(Duration elapsed) {
    if (state == null) return;
    state = state!.copyWith(elapsed: elapsed);
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState?>((ref) {
  return GameNotifier();
});
