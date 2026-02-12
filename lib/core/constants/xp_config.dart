import '../../core/enums/difficulty.dart';

class XpConfig {
  XpConfig._();

  // --- Max level ---
  static const int maxLevel = 30;

  // --- Base XP per difficulty (only on win) ---
  static const int baseXpOneSuit = 50;
  static const int baseXpTwoSuits = 100;
  static const int baseXpFourSuits = 200;

  // --- Time multiplier (1.0x – 1.5x) ---
  static const double timeTargetMinutes = 5.0;
  static const double timeSlowMinutes = 20.0;
  static const double maxTimeMultiplier = 1.5;

  // --- Moves multiplier (1.0x – 1.5x) ---
  static const int movesTarget = 80;
  static const int movesSlow = 200;
  static const double maxMovesMultiplier = 1.5;

  // --- XP required to advance FROM level to level+1 ---
  static int xpForLevel(int level) => level * 100;

  // --- Calculate XP earned for a win ---
  static int calculateXp({
    required Difficulty difficulty,
    required Duration time,
    required int moves,
  }) {
    final int base = switch (difficulty) {
      Difficulty.oneSuit => baseXpOneSuit,
      Difficulty.twoSuits => baseXpTwoSuits,
      Difficulty.fourSuits => baseXpFourSuits,
    };
    final double timeMult = _lerp(
      time.inMinutes.toDouble(),
      timeTargetMinutes,
      timeSlowMinutes,
      maxTimeMultiplier,
      1.0,
    );
    final double movesMult = _lerp(
      moves.toDouble(),
      movesTarget.toDouble(),
      movesSlow.toDouble(),
      maxMovesMultiplier,
      1.0,
    );
    return (base * timeMult * movesMult).round();
  }

  /// Linear interpolation: value <= low → highResult, value >= high → lowResult.
  static double _lerp(
    double value,
    double low,
    double high,
    double lowResult,
    double highResult,
  ) {
    if (value <= low) return lowResult;
    if (value >= high) return highResult;
    final double t = (value - low) / (high - low);
    return lowResult + t * (highResult - lowResult);
  }
}
