import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/enums/difficulty.dart';
import '../models/settings_state.dart';
import '../models/shop_item.dart';

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(const SettingsState()) {
    _loadPrefs();
  }

  static const _keyHasSelectedLanguage = 'hasSelectedLanguage';
  static const _keyLocale = 'locale';
  static const _keyBackground = 'selectedBackground';
  static const _keyCardBack = 'selectedCardBack';

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSelected = prefs.getBool(_keyHasSelectedLanguage) ?? false;
    final localeCode = prefs.getString(_keyLocale);
    final bgName = prefs.getString(_keyBackground);
    final cbName = prefs.getString(_keyCardBack);

    BackgroundOption bg = BackgroundOption.image1;
    if (bgName != null) {
      bg = BackgroundOption.values.firstWhere(
        (BackgroundOption e) => e.name == bgName,
        orElse: () => BackgroundOption.image1,
      );
    }

    CardBackOption cb = CardBackOption.image1;
    if (cbName != null) {
      cb = CardBackOption.values.firstWhere(
        (CardBackOption e) => e.name == cbName,
        orElse: () => CardBackOption.image1,
      );
    }

    state = state.copyWith(
      hasSelectedLanguage: hasSelected && localeCode != null ? true : null,
      locale: hasSelected && localeCode != null ? Locale(localeCode) : null,
      selectedBackground: bg,
      selectedCardBack: cb,
      isLoading: false,
    );
  }

  Future<void> _saveLanguagePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyHasSelectedLanguage, state.hasSelectedLanguage);
    await prefs.setString(_keyLocale, state.locale.languageCode);
  }

  Future<void> _saveShopPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBackground, state.selectedBackground.name);
    await prefs.setString(_keyCardBack, state.selectedCardBack.name);
  }

  void setDefaultDifficulty(Difficulty difficulty) {
    state = state.copyWith(defaultDifficulty: difficulty);
  }

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  void toggleConfirmNewGame() {
    state = state.copyWith(confirmNewGame: !state.confirmNewGame);
  }

  void setLocale(Locale locale) {
    state = state.copyWith(locale: locale);
    _saveLanguagePrefs();
  }

  void toggleAllowDealWithEmptyColumns() {
    state = state.copyWith(
      allowDealWithEmptyColumns: !state.allowDealWithEmptyColumns,
    );
  }

  void toggleHighlightMovable() {
    state = state.copyWith(highlightMovable: !state.highlightMovable);
  }

  void toggleTapToAutoMove() {
    state = state.copyWith(tapToAutoMove: !state.tapToAutoMove);
  }

  void toggleMusic() {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
  }

  void setHasSelectedLanguage(bool value) {
    state = state.copyWith(hasSelectedLanguage: value);
    _saveLanguagePrefs();
  }

  void setBackground(BackgroundOption option) {
    state = state.copyWith(selectedBackground: option);
    _saveShopPrefs();
  }

  void setCardBack(CardBackOption option) {
    state = state.copyWith(selectedCardBack: option);
    _saveShopPrefs();
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
