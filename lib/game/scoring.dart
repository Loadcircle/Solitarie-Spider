import '../core/constants/game_constants.dart';

class Scoring {
  Scoring._();

  static int calculateScore({
    required int moveCount,
    required int completedSequences,
    required bool isWon,
  }) {
    var score = GameConstants.initialScore;
    score -= moveCount * GameConstants.movePointPenalty;
    score += completedSequences * GameConstants.sequenceBonus;
    if (isWon) score += GameConstants.winBonus;
    return score;
  }
}
