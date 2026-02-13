import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums/difficulty.dart';
import '../models/game_state.dart';
import '../game/game_engine.dart';

class GameNotifier extends StateNotifier<GameState?> {
  GameNotifier() : super(null);

  GameState? _previousState;

  void startNewGame(Difficulty difficulty) {
    _previousState = null;
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
      _previousState = state;
      state = newState.copyWith(canUndo: true);
    }
  }

  void dealFromStock({bool allowEmptyColumns = false}) {
    if (state == null) return;
    final newState = GameEngine.dealFromStock(
      state!,
      allowEmptyColumns: allowEmptyColumns,
    );
    if (newState != null) {
      _previousState = state;
      state = newState.copyWith(canUndo: true);
    }
  }

  void undo() {
    if (_previousState == null || state == null || !state!.canUndo) return;
    state = _previousState!.copyWith(elapsed: state!.elapsed, canUndo: false);
    _previousState = null;
  }

  void updateElapsed(Duration elapsed) {
    if (state == null) return;
    state = state!.copyWith(elapsed: elapsed);
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState?>((ref) {
  return GameNotifier();
});
