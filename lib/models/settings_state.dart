import 'dart:ui';
import '../core/constants/shop_registry.dart';
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
  final bool undoEnabled;
  final bool hasSelectedLanguage;
  final bool isLoading;
  final BackgroundItem selectedBackground;
  final CardBackItem selectedCardBack;
  final FigureItem selectedFigure;

  const SettingsState({
    this.defaultDifficulty = Difficulty.oneSuit,
    this.soundEnabled = true,
    this.musicEnabled = false,
    this.confirmNewGame = true,
    this.locale = const Locale('en'),
    this.allowDealWithEmptyColumns = false,
    this.highlightMovable = true,
    this.tapToAutoMove = true,
    this.undoEnabled = true,
    this.hasSelectedLanguage = false,
    this.isLoading = true,
    this.selectedBackground = ShopRegistry.defaultBackground,
    this.selectedCardBack = ShopRegistry.defaultCardBack,
    this.selectedFigure = ShopRegistry.defaultFigure,
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
    bool? undoEnabled,
    bool? hasSelectedLanguage,
    bool? isLoading,
    BackgroundItem? selectedBackground,
    CardBackItem? selectedCardBack,
    FigureItem? selectedFigure,
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
      undoEnabled: undoEnabled ?? this.undoEnabled,
      hasSelectedLanguage: hasSelectedLanguage ?? this.hasSelectedLanguage,
      isLoading: isLoading ?? this.isLoading,
      selectedBackground: selectedBackground ?? this.selectedBackground,
      selectedCardBack: selectedCardBack ?? this.selectedCardBack,
      selectedFigure: selectedFigure ?? this.selectedFigure,
    );
  }
}
