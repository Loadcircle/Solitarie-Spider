import 'dart:ui';
import '../core/enums/difficulty.dart';
import 'shop_item.dart';

class SettingsState {
  final Difficulty defaultDifficulty;
  final bool soundEnabled;
  final bool musicEnabled;
  final bool confirmNewGame;
  final Locale locale;
  final bool allowDealWithEmptyColumns;
  final bool highlightMovable;
  final bool tapToAutoMove;
  final bool hasSelectedLanguage;
  final bool isLoading;
  final BackgroundOption selectedBackground;
  final CardBackOption selectedCardBack;

  const SettingsState({
    this.defaultDifficulty = Difficulty.oneSuit,
    this.soundEnabled = true,
    this.musicEnabled = false,
    this.confirmNewGame = true,
    this.locale = const Locale('en'),
    this.allowDealWithEmptyColumns = false,
    this.highlightMovable = true,
    this.tapToAutoMove = true,
    this.hasSelectedLanguage = false,
    this.isLoading = true,
    this.selectedBackground = BackgroundOption.image1,
    this.selectedCardBack = CardBackOption.image1,
  });

  SettingsState copyWith({
    Difficulty? defaultDifficulty,
    bool? soundEnabled,
    bool? musicEnabled,
    bool? confirmNewGame,
    Locale? locale,
    bool? allowDealWithEmptyColumns,
    bool? highlightMovable,
    bool? tapToAutoMove,
    bool? hasSelectedLanguage,
    bool? isLoading,
    BackgroundOption? selectedBackground,
    CardBackOption? selectedCardBack,
  }) {
    return SettingsState(
      defaultDifficulty: defaultDifficulty ?? this.defaultDifficulty,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      confirmNewGame: confirmNewGame ?? this.confirmNewGame,
      locale: locale ?? this.locale,
      allowDealWithEmptyColumns:
          allowDealWithEmptyColumns ?? this.allowDealWithEmptyColumns,
      highlightMovable: highlightMovable ?? this.highlightMovable,
      tapToAutoMove: tapToAutoMove ?? this.tapToAutoMove,
      hasSelectedLanguage: hasSelectedLanguage ?? this.hasSelectedLanguage,
      isLoading: isLoading ?? this.isLoading,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      selectedCardBack: selectedCardBack ?? this.selectedCardBack,
    );
  }
}
