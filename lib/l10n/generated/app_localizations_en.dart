// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Spider Solitaire';

  @override
  String get home => 'Home';

  @override
  String get newGame => 'New Game';

  @override
  String get continueGame => 'Continue';

  @override
  String get history => 'History';

  @override
  String get ranking => 'Ranking';

  @override
  String get settings => 'Settings';

  @override
  String get score => 'Score';

  @override
  String get moves => 'Moves';

  @override
  String get time => 'Time';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get oneSuit => '1 Suit';

  @override
  String get twoSuits => '2 Suits';

  @override
  String get fourSuits => '4 Suits';

  @override
  String get easy => 'Easy';

  @override
  String get medium => 'Medium';

  @override
  String get hard => 'Hard';

  @override
  String get start => 'Start';

  @override
  String get youWin => 'You Win!';

  @override
  String get congratulations => 'Congratulations! You completed the game.';

  @override
  String finalScore(int score) {
    return 'Final Score: $score';
  }

  @override
  String totalMoves(int moves) {
    return 'Total Moves: $moves';
  }

  @override
  String totalTime(String time) {
    return 'Time: $time';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get noHistory => 'No games played yet.';

  @override
  String get date => 'Date';

  @override
  String get result => 'Result';

  @override
  String get won => 'Won';

  @override
  String get lost => 'Lost';

  @override
  String get confirmNewGame => 'Confirm New Game';

  @override
  String get confirmNewGameMessage =>
      'Are you sure you want to start a new game? Current progress will be lost.';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get sound => 'Sound';

  @override
  String get animations => 'Animations';

  @override
  String get defaultDifficulty => 'Default Difficulty';

  @override
  String get confirmBeforeNewGame => 'Confirm before new game';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get stockEmpty => 'Stock is empty';

  @override
  String get allColumnsMustHaveCards =>
      'All columns must have at least one card to deal.';

  @override
  String get sequences => 'Sequences';

  @override
  String get stock => 'Stock';

  @override
  String get deals => 'deals';
}
