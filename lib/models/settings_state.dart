import 'dart:ui';
import '../core/enums/difficulty.dart';

class SettingsState {
  final Difficulty defaultDifficulty;
  final bool soundEnabled;
  final bool animationsEnabled;
  final bool confirmNewGame;
  final Locale locale;

  const SettingsState({
    this.defaultDifficulty = Difficulty.oneSuit,
    this.soundEnabled = true,
    this.animationsEnabled = true,
    this.confirmNewGame = true,
    this.locale = const Locale('en'),
  });

  SettingsState copyWith({
    Difficulty? defaultDifficulty,
    bool? soundEnabled,
    bool? animationsEnabled,
    bool? confirmNewGame,
    Locale? locale,
  }) {
    return SettingsState(
      defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      confirmNewGame: confirmNewGame ?? this.confirmNewGame,
      locale: locale ?? this.locale,
    );
  }
}
