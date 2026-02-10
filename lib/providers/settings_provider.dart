import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/enums/difficulty.dart';
import '../models/settings_state.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState());

  void setDefaultDifficulty(Difficulty difficulty) {
    state = state.copyWith(defaultDifficulty: difficulty);
  }

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  void toggleAnimations() {
    state = state.copyWith(animationsEnabled: !state.animationsEnabled);
  }

  void toggleConfirmNewGame() {
    state = state.copyWith(confirmNewGame: !state.confirmNewGame);
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
