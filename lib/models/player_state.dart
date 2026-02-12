class PlayerState {
  final int level;
  final int currentXp;
  final int totalXp;
  final int lastRewardShownLevel;

  const PlayerState({
    this.level = 1,
    this.currentXp = 0,
    this.totalXp = 0,
    this.lastRewardShownLevel = 1,
  });

  PlayerState copyWith({
    int? level,
    int? currentXp,
    int? totalXp,
    int? lastRewardShownLevel,
  }) {
    return PlayerState(
      level: level ?? this.level,
      currentXp: currentXp ?? this.currentXp,
      totalXp: totalXp ?? this.totalXp,
      lastRewardShownLevel:
          lastRewardShownLevel ?? this.lastRewardShownLevel,
    );
  }
}
