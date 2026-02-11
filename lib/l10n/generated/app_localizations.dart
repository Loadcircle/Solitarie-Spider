import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Spider Solitaire'**
  String get appTitle;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGame;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @ranking.
  ///
  /// In en, this message translates to:
  /// **'Ranking'**
  String get ranking;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @moves.
  ///
  /// In en, this message translates to:
  /// **'Moves'**
  String get moves;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @oneSuit.
  ///
  /// In en, this message translates to:
  /// **'1 Suit'**
  String get oneSuit;

  /// No description provided for @twoSuits.
  ///
  /// In en, this message translates to:
  /// **'2 Suits'**
  String get twoSuits;

  /// No description provided for @fourSuits.
  ///
  /// In en, this message translates to:
  /// **'4 Suits'**
  String get fourSuits;

  /// No description provided for @easy.
  ///
  /// In en, this message translates to:
  /// **'Easy'**
  String get easy;

  /// No description provided for @medium.
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// No description provided for @hard.
  ///
  /// In en, this message translates to:
  /// **'Hard'**
  String get hard;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @youWin.
  ///
  /// In en, this message translates to:
  /// **'You Win!'**
  String get youWin;

  /// No description provided for @congratulations.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! You completed the game.'**
  String get congratulations;

  /// No description provided for @finalScore.
  ///
  /// In en, this message translates to:
  /// **'Final Score: {score}'**
  String finalScore(int score);

  /// No description provided for @totalMoves.
  ///
  /// In en, this message translates to:
  /// **'Total Moves: {moves}'**
  String totalMoves(int moves);

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Time: {time}'**
  String totalTime(String time);

  /// No description provided for @playAgain.
  ///
  /// In en, this message translates to:
  /// **'Play Again'**
  String get playAgain;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @noHistory.
  ///
  /// In en, this message translates to:
  /// **'No games played yet.'**
  String get noHistory;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'Result'**
  String get result;

  /// No description provided for @won.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get won;

  /// No description provided for @lost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get lost;

  /// No description provided for @confirmNewGame.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Game'**
  String get confirmNewGame;

  /// No description provided for @confirmNewGameMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to start a new game? Current progress will be lost.'**
  String get confirmNewGameMessage;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @sound.
  ///
  /// In en, this message translates to:
  /// **'Sound'**
  String get sound;

  /// No description provided for @defaultDifficulty.
  ///
  /// In en, this message translates to:
  /// **'Default Difficulty'**
  String get defaultDifficulty;

  /// No description provided for @confirmBeforeNewGame.
  ///
  /// In en, this message translates to:
  /// **'Confirm before new game'**
  String get confirmBeforeNewGame;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @stockEmpty.
  ///
  /// In en, this message translates to:
  /// **'Stock is empty'**
  String get stockEmpty;

  /// No description provided for @allColumnsMustHaveCards.
  ///
  /// In en, this message translates to:
  /// **'All columns must have at least one card to deal.'**
  String get allColumnsMustHaveCards;

  /// No description provided for @sequences.
  ///
  /// In en, this message translates to:
  /// **'Sequences'**
  String get sequences;

  /// No description provided for @stock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get stock;

  /// No description provided for @deals.
  ///
  /// In en, this message translates to:
  /// **'deals'**
  String get deals;

  /// No description provided for @gamePaused.
  ///
  /// In en, this message translates to:
  /// **'Game Paused'**
  String get gamePaused;

  /// No description provided for @allowDealWithEmptyColumns.
  ///
  /// In en, this message translates to:
  /// **'Allow deal with empty columns'**
  String get allowDealWithEmptyColumns;

  /// No description provided for @allowDealWithEmptyColumnsDescription.
  ///
  /// In en, this message translates to:
  /// **'Allow dealing even when some columns are empty'**
  String get allowDealWithEmptyColumnsDescription;

  /// No description provided for @highlightMovable.
  ///
  /// In en, this message translates to:
  /// **'Highlight movable cards'**
  String get highlightMovable;

  /// No description provided for @highlightMovableDescription.
  ///
  /// In en, this message translates to:
  /// **'Dim cards that cannot be picked up'**
  String get highlightMovableDescription;

  /// No description provided for @tapToAutoMove.
  ///
  /// In en, this message translates to:
  /// **'Tap to auto-move'**
  String get tapToAutoMove;

  /// No description provided for @tapToAutoMoveDescription.
  ///
  /// In en, this message translates to:
  /// **'Tap a card to move it to the best column'**
  String get tapToAutoMoveDescription;

  /// No description provided for @noValidMove.
  ///
  /// In en, this message translates to:
  /// **'No valid move available'**
  String get noValidMove;

  /// No description provided for @youLose.
  ///
  /// In en, this message translates to:
  /// **'Game Over'**
  String get youLose;

  /// No description provided for @noMovesLeft.
  ///
  /// In en, this message translates to:
  /// **'No more moves available. Better luck next time!'**
  String get noMovesLeft;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @portuguese.
  ///
  /// In en, this message translates to:
  /// **'Portuguese'**
  String get portuguese;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @chooseLanguageMessage.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred language'**
  String get chooseLanguageMessage;

  /// No description provided for @shop.
  ///
  /// In en, this message translates to:
  /// **'Shop'**
  String get shop;

  /// No description provided for @backgrounds.
  ///
  /// In en, this message translates to:
  /// **'Backgrounds'**
  String get backgrounds;

  /// No description provided for @cardBacks.
  ///
  /// In en, this message translates to:
  /// **'Card Backs'**
  String get cardBacks;

  /// No description provided for @bgDefaultGreen.
  ///
  /// In en, this message translates to:
  /// **'Classic Green'**
  String get bgDefaultGreen;

  /// No description provided for @bgDarkEmerald.
  ///
  /// In en, this message translates to:
  /// **'Dark Emerald'**
  String get bgDarkEmerald;

  /// No description provided for @bgImage1.
  ///
  /// In en, this message translates to:
  /// **'Felt Texture'**
  String get bgImage1;

  /// No description provided for @bgImage2.
  ///
  /// In en, this message translates to:
  /// **'Ornate Felt'**
  String get bgImage2;

  /// No description provided for @cbDefaultBlue.
  ///
  /// In en, this message translates to:
  /// **'Classic Blue'**
  String get cbDefaultBlue;

  /// No description provided for @cbDarkRed.
  ///
  /// In en, this message translates to:
  /// **'Dark Red'**
  String get cbDarkRed;

  /// No description provided for @cbImage1.
  ///
  /// In en, this message translates to:
  /// **'Red Crosshatch'**
  String get cbImage1;

  /// No description provided for @cbImage2.
  ///
  /// In en, this message translates to:
  /// **'Royal Spade'**
  String get cbImage2;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @fastestTime.
  ///
  /// In en, this message translates to:
  /// **'Fastest Time'**
  String get fastestTime;

  /// No description provided for @averageTime.
  ///
  /// In en, this message translates to:
  /// **'Average Time'**
  String get averageTime;

  /// No description provided for @longestWinStreak.
  ///
  /// In en, this message translates to:
  /// **'Longest Win Streak'**
  String get longestWinStreak;

  /// No description provided for @bestScore.
  ///
  /// In en, this message translates to:
  /// **'Best Score'**
  String get bestScore;

  /// No description provided for @noStats.
  ///
  /// In en, this message translates to:
  /// **'No stats yet for this mode.'**
  String get noStats;

  /// No description provided for @noGamesOnDay.
  ///
  /// In en, this message translates to:
  /// **'No games on this day.'**
  String get noGamesOnDay;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
