import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'game_provider.dart';

class TimerNotifier extends StateNotifier<Duration> {
  TimerNotifier(this._ref) : super(Duration.zero);

  final Ref _ref;
  Timer? _timer;

  void start() {
    _timer?.cancel();
    state = Duration.zero;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state + const Duration(seconds: 1);
      _ref.read(gameProvider.notifier).updateElapsed(state);
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void resume() {
    if (_timer != null) return;
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      state = state + const Duration(seconds: 1);
      _ref.read(gameProvider.notifier).updateElapsed(state);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final timerProvider =
    StateNotifierProvider<TimerNotifier, Duration>((ref) {
  return TimerNotifier(ref);
});
