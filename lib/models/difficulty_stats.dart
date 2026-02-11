class DifficultyStats {
  final Duration? fastestTime;
  final Duration averageTime;
  final int longestWinStreak;
  final int bestScore;
  final int totalGames;

  const DifficultyStats({
    required this.fastestTime,
    required this.averageTime,
    required this.longestWinStreak,
    required this.bestScore,
    required this.totalGames,
  });
}
