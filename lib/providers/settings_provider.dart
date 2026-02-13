import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/shop_registry.dart';
import '../core/enums/difficulty.dart';
import '../core/services/notification_service.dart';
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
  static const _keyFigure = 'selectedFigure';
  static const _keyStreakReminder = 'streakReminderEnabled';
  static const _keyRewardAlert = 'rewardAlertEnabled';

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSelected = prefs.getBool(_keyHasSelectedLanguage) ?? false;
    final localeCode = prefs.getString(_keyLocale);
    final bgName = prefs.getString(_keyBackground);
    final cbName = prefs.getString(_keyCardBack);
    final figName = prefs.getString(_keyFigure);

    final BackgroundItem bg = bgName != null
        ? ShopRegistry.backgroundById(bgName)
        : ShopRegistry.defaultBackground;

    final CardBackItem cb = cbName != null
        ? ShopRegistry.cardBackById(cbName)
        : ShopRegistry.defaultCardBack;

    final FigureItem fig = figName != null
        ? ShopRegistry.figureById(figName)
        : ShopRegistry.defaultFigure;

    final bool streakReminder = prefs.getBool(_keyStreakReminder) ?? true;
    final bool rewardAlert = prefs.getBool(_keyRewardAlert) ?? true;

    state = state.copyWith(
      hasSelectedLanguage: hasSelected && localeCode != null ? true : null,
      locale: hasSelected && localeCode != null ? Locale(localeCode) : null,
      selectedBackground: bg,
      selectedCardBack: cb,
      selectedFigure: fig,
      streakReminderEnabled: streakReminder,
      rewardAlertEnabled: rewardAlert,
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
    await prefs.setString(_keyBackground, state.selectedBackground.id);
    await prefs.setString(_keyCardBack, state.selectedCardBack.id);
    await prefs.setString(_keyFigure, state.selectedFigure.id);
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
    // Notification text depends on locale — re-scheduling is handled by the
    // caller (UI) which has access to AppLocalizations.
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

  void toggleUndo() {
    state = state.copyWith(undoEnabled: !state.undoEnabled);
  }

  void toggleMusic() {
    state = state.copyWith(musicEnabled: !state.musicEnabled);
  }

  void setHasSelectedLanguage(bool value) {
    state = state.copyWith(hasSelectedLanguage: value);
    _saveLanguagePrefs();
  }

  void setBackground(BackgroundItem option) {
    state = state.copyWith(selectedBackground: option);
    _saveShopPrefs();
  }

  void setCardBack(CardBackItem option) {
    state = state.copyWith(selectedCardBack: option);
    _saveShopPrefs();
  }

  void setFigure(FigureItem option) {
    state = state.copyWith(selectedFigure: option);
    _saveShopPrefs();
  }

  Future<void> toggleStreakReminder({
    required String title,
    required String body,
  }) async {
    final bool newValue = !state.streakReminderEnabled;
    state = state.copyWith(streakReminderEnabled: newValue);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyStreakReminder, newValue);

    final NotificationService ns = NotificationService.instance;
    if (newValue) {
      await ns.scheduleDailyStreak(title: title, body: body);
    } else {
      await ns.cancelDailyStreak();
    }
  }

  Future<void> toggleRewardAlert() async {
    final bool newValue = !state.rewardAlertEnabled;
    state = state.copyWith(rewardAlertEnabled: newValue);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRewardAlert, newValue);

    if (!newValue) {
      await NotificationService.instance.cancelRewardProximity();
    }
  }

  /// Reset selections to defaults if the current items are locked at [playerLevel].
  void validateSelections(int playerLevel) {
    final unlocked = ShopRegistry.unlockedItemsForLevel(playerLevel);
    bool changed = false;

    BackgroundItem bg = state.selectedBackground;
    if (ShopRegistry.requiredLevelFor(bg) != null && !unlocked.contains(bg)) {
      bg = ShopRegistry.defaultBackground;
      changed = true;
    }

    CardBackItem cb = state.selectedCardBack;
    if (ShopRegistry.requiredLevelFor(cb) != null && !unlocked.contains(cb)) {
      cb = ShopRegistry.defaultCardBack;
      changed = true;
    }

    FigureItem fig = state.selectedFigure;
    if (ShopRegistry.requiredLevelFor(fig) != null && !unlocked.contains(fig)) {
      fig = ShopRegistry.defaultFigure;
      changed = true;
    }

    if (changed) {
      state = state.copyWith(
        selectedBackground: bg,
        selectedCardBack: cb,
        selectedFigure: fig,
      );
      _saveShopPrefs();
    }
  }
}

final settingsProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
