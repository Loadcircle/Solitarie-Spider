import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/constants/shop_registry.dart';
import '../core/constants/xp_config.dart';
import '../models/player_state.dart';

class PlayerNotifier extends StateNotifier<PlayerState> {
  PlayerNotifier() : super(const PlayerState()) {
    _loadPrefs();
  }

  static const _keyLevel = 'player_level';
  static const _keyCurrentXp = 'player_currentXp';
  static const _keyTotalXp = 'player_totalXp';
  static const _keyLastRewardShown = 'player_lastRewardShownLevel';

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final level = prefs.getInt(_keyLevel) ?? 1;
    state = state.copyWith(
      level: level,
      currentXp: prefs.getInt(_keyCurrentXp) ?? 0,
      totalXp: prefs.getInt(_keyTotalXp) ?? 0,
      lastRewardShownLevel: prefs.getInt(_keyLastRewardShown) ?? level,
    );
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLevel, state.level);
    await prefs.setInt(_keyCurrentXp, state.currentXp);
    await prefs.setInt(_keyTotalXp, state.totalXp);
    await prefs.setInt(_keyLastRewardShown, state.lastRewardShownLevel);
  }

  void addXp(int xp) {
    int level = state.level;
    int currentXp = state.currentXp + xp;
    int totalXp = state.totalXp + xp;

    while (level < XpConfig.maxLevel &&
        currentXp >= XpConfig.xpForLevel(level + 1)) {
      currentXp -= XpConfig.xpForLevel(level + 1);
      level++;
    }

    if (level == XpConfig.maxLevel) {
      currentXp = 0;
    }

    state = state.copyWith(
      level: level,
      currentXp: currentXp,
      totalXp: totalXp,
    );
    _persist();
  }

  /// Mark that the player has seen reward notifications up to current level.
  void markRewardsShown() {
    state = state.copyWith(lastRewardShownLevel: state.level);
    _persist();
  }

  bool isItemUnlocked(Object item) {
    // Items with no unlockLevel are always available
    return ShopRegistry.requiredLevelFor(item) == null ||
        ShopRegistry.unlockedItemsForLevel(state.level).contains(item);
  }
}

final playerProvider =
    StateNotifierProvider<PlayerNotifier, PlayerState>((Ref ref) {
  return PlayerNotifier();
});
