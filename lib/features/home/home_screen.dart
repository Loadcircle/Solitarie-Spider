import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/ads/banner_ad_widget.dart';
import '../../core/constants/shop_registry.dart';
import '../../core/constants/xp_config.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/player_state.dart';
import '../../models/shop_item.dart';
import '../../providers/player_provider.dart';
import '../../routes/app_router.dart';
import '../../models/game_result.dart';
import '../../models/settings_state.dart';
import '../../providers/game_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/settings_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasShownLanguageDialog = false;
  bool _hasCheckedUnlocks = false;

  @override
  void initState() {
    super.initState();
    // Listen for settings to finish loading, then show language picker if needed
    ref.listenManual(settingsProvider, (SettingsState? previous, SettingsState next) {
      if (next.isLoading || next.hasSelectedLanguage) return;
      if (_hasShownLanguageDialog) return;
      _hasShownLanguageDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _showLanguagePickerDialog();
      });
    }, fireImmediately: true);

    // Check for newly unlocked rewards each time home screen appears
    ref.listenManual(playerProvider, (PlayerState? previous, PlayerState next) {
      if (_hasCheckedUnlocks) return;
      // Wait until lastRewardShownLevel is loaded (non-default state)
      if (next.totalXp == 0 && next.level == 1) return;
      _hasCheckedUnlocks = true;
      final newItems = ShopRegistry.itemsUnlockedBetween(
        next.lastRewardShownLevel,
        next.level,
      );
      if (newItems.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _showUnlockDialog(newItems);
          ref.read(playerProvider.notifier).markRewardsShown();
        });
      }
    }, fireImmediately: true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset check when returning to home (e.g. from game board)
    _hasCheckedUnlocks = false;
  }

  void _showLanguagePickerDialog() {
    final notifier = ref.read(settingsProvider.notifier);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1F3A24), Color(0xFF0F1E12)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A4A2E)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose Language\nElegir Idioma\nEscolher Idioma',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText),
              ),
              const SizedBox(height: 16),
              _languageOption(ctx, 'EN', 'English', const Locale('en'), notifier),
              Divider(color: const Color(0xFF2A4A2E), height: 1),
              _languageOption(ctx, 'ES', 'Español', const Locale('es'), notifier),
              Divider(color: const Color(0xFF2A4A2E), height: 1),
              _languageOption(ctx, 'PT', 'Português', const Locale('pt'), notifier),
            ],
          ),
        ),
      ),
    );
  }

  void _showUnlockDialog(List<Object> items) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).languageCode;

    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1F3A24), Color(0xFF0F1E12)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF2A4A2E)),
            boxShadow: const [
              BoxShadow(
                  color: Colors.black45, blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('\u{1F389}', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text(
                l10n.newUnlocks,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                l10n.newUnlocksMessage,
                textAlign: TextAlign.center,
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  for (final item in items)
                    _UnlockItemPreview(item: item, locale: locale),
                ],
              ),
              const SizedBox(height: 24),
              AppButton(
                icon: Icons.store,
                label: l10n.goToShop,
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.pushNamed(context, AppRouter.shop);
                },
                isPrimary: true,
              ),
              const SizedBox(height: 10),
              AppButton(
                label: l10n.close,
                onPressed: () => Navigator.of(ctx).pop(),
                isPrimary: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _languageOption(BuildContext ctx, String code, String name,
      Locale locale, SettingsNotifier notifier) {
    return ListTile(
      leading: Text(code,
          style: TextStyle(
              fontWeight: FontWeight.bold, color: AppTheme.primaryText)),
      title:
          Text(name, style: TextStyle(color: AppTheme.primaryText)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: () {
        notifier.setLocale(locale);
        notifier.setHasSelectedLanguage(true);
        Navigator.of(ctx).pop();
      },
    );
  }

  void _onNewGame(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(gameProvider);
    final settings = ref.read(settingsProvider);
    final hasActiveGame = gameState != null && gameState.isStarted && !gameState.isWon;

    if (hasActiveGame && settings.confirmNewGame) {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (ctx) => Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1F3A24), Color(0xFF0F1E12)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF2A4A2E)),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black45,
                    blurRadius: 12,
                    offset: Offset(0, 4)),
              ],
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.confirmNewGame,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryText,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.confirmNewGameMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppTheme.secondaryText),
                ),
                const SizedBox(height: 24),
                AppButton(
                  icon: Icons.add,
                  label: l10n.confirm,
                  onPressed: () {
                    // Record abandon for the active game
                    final gs = ref.read(gameProvider);
                    if (gs != null && gs.isStarted && !gs.isWon) {
                      ref.read(historyProvider.notifier).addResult(GameResult(
                            dateTime: DateTime.now(),
                            difficulty: gs.difficulty,
                            score: gs.score,
                            time: gs.elapsed,
                            moves: gs.moveCount,
                            isWon: false,
                          ));
                    }
                    Navigator.of(ctx).pop();
                    Navigator.pushNamed(context, AppRouter.newGame);
                  },
                  isPrimary: true,
                ),
                const SizedBox(height: 10),
                AppButton(
                  label: l10n.cancel,
                  onPressed: () => Navigator.of(ctx).pop(),
                  isPrimary: false,
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      Navigator.pushNamed(context, AppRouter.newGame);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final gameState = ref.watch(gameProvider);
    final playerState = ref.watch(playerProvider);
    final hasActiveGame = gameState != null && gameState.isStarted && !gameState.isWon;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.3),
                radius: 0.85,
                colors: [Color(0xFF1E5E2A), Color(0xFF0A1A0E)],
              ),
            ),
          ),
          SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(32, 40, 32, 32), // 👈 SUBE logo
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_clean.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 20),
                    _LevelProgressBar(
                      playerState: playerState,
                      l10n: l10n,
                    ),
                    const SizedBox(height: 20),
                    if (hasActiveGame) ...[
                      AppButton(
                        icon: Icons.play_arrow,
                        label: l10n.continueGame,
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRouter.gameBoard),
                        isGold: true,
                      ),
                      const SizedBox(height: 12),
                    ],
                    AppButton(
                      icon: Icons.add,
                      label: l10n.newGame,
                      onPressed: () => _onNewGame(context, ref),
                      isPrimary: true,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      icon: Icons.history,
                      label: l10n.history,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRouter.history),
                      isPrimary: false,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      icon: Icons.leaderboard,
                      label: l10n.ranking,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRouter.ranking),
                      isPrimary: false,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      icon: Icons.store,
                      label: l10n.shop,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRouter.shop),
                      isPrimary: false,
                    ),
                    const SizedBox(height: 12),
                    AppButton(
                      icon: Icons.settings,
                      label: l10n.settings,
                      onPressed: () =>
                          Navigator.pushNamed(context, AppRouter.settings),
                      isPrimary: false,
                    ),
                    const SizedBox(height: 40),
                    const BannerAdWidget(),
                  ],
                ),
              ),
            ),

        ],
      ),
    );
  }
}

class _LevelProgressBar extends StatelessWidget {
  const _LevelProgressBar({
    required this.playerState,
    required this.l10n,
  });

  final PlayerState playerState;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final bool isMax = playerState.level >= XpConfig.maxLevel;

    final int currentLevel = playerState.level;
    final int nextLevel = isMax ? currentLevel : (currentLevel + 1);

    final int xpNeeded = isMax ? 1 : XpConfig.xpForLevel(nextLevel);
    final double progress =
        isMax ? 1.0 : (playerState.currentXp / xpNeeded).clamp(0.0, 1.0);

    final nextReward = ShopRegistry.nextRewardAfter(currentLevel);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        children: [
          // TOP: Level + Bar + Next Level
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLevelCircle(currentLevel, isGhost: false, isNext: false),
              const SizedBox(width: 10),

              Expanded(
                child: SizedBox(
                  height: 40, // 👈 mismo alto que círculos
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // 👈 centra en Y
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: SizedBox(
                          height: 20,
                          child: Stack(
                            children: [
                              Container(color: const Color(0xFF1A2E1E)),
                              FractionallySizedBox(
                                widthFactor: progress,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF4CAF50),
                                        Color(0xFFFFD54F),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isMax ? l10n.maxLevel : '${playerState.currentXp}/$xpNeeded XP',
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),
              _buildLevelCircle(nextLevel, isGhost: isMax, isNext: true),
            ],
          ),

          if (nextReward != null) ...[
            const SizedBox(height: 10),

            // BOTTOM: Reward banner centered + gradient strip
            _buildRewardBanner(nextReward, context),
          ],
        ],
      ),
    );

  }

  Widget _buildLevelCircle(int level, {required bool isGhost, required bool isNext}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: isGhost
            ? LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.12),
                  Colors.white.withOpacity(0.06),
                ],
              )
            : const LinearGradient(
                colors: [Color(0xFF4CAF50), Color(0xFF2E7D32)],
              ),
        border: Border.all(
          // 👇 Actual = amarillo, Next = verde
          color: isNext ? const Color.fromARGB(255, 117, 230, 121) : const Color(0xFFFFD54F),
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$level',
          style: TextStyle(
            color: isGhost ? Colors.white70 : Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 16,
          ),
        ),
      ),
    );
  }


  Widget _buildRewardBanner(({int level, Object reward}) nextReward, context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.black.withOpacity(0.0),   // 👈 izquierda transparente
            Colors.black.withOpacity(0.35),  // 👈 centro visible
            Colors.black.withOpacity(0.0),   // 👈 derecha transparente
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center, // 👈 centra todo el grupo
        mainAxisSize: MainAxisSize.max,
        children: [
          const Icon(Icons.emoji_events, size: 16, color: Color(0xFFFFD54F)),
          const SizedBox(width: 8),
          Text(
            l10n.nextRewardAtLevel(nextReward.level),
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 11,
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: () {
              Navigator.pushNamed(context, AppRouter.shop);
            },
            child: SizedBox(
              width: 26,
              height: 26,
              child: _buildRewardPreviewOnly(nextReward),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildRewardPreviewOnly(({int level, Object reward}) nextReward) {
    final Object reward = nextReward.reward;

    if (reward is BackgroundItem) {
      if (reward.isImage) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(reward.assetPath!, fit: BoxFit.cover),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: reward.color,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    if (reward is CardBackItem) {
      if (reward.isImage) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Image.asset(reward.assetPath!, fit: BoxFit.cover),
        );
      }
      return Container(
        decoration: BoxDecoration(
          color: reward.color,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Center(
          child: Text(
            '\u2660',
            style: TextStyle(
              color: reward.colorPattern,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (reward is FigureItem) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: Image.asset(reward.previewPath, fit: BoxFit.cover),
      );
    }

    return const Icon(Icons.help_outline, color: Colors.white54);
  }
}

class _UnlockItemPreview extends StatelessWidget {
  const _UnlockItemPreview({required this.item, required this.locale});

  final Object item;
  final String locale;

  @override
  Widget build(BuildContext context) {
    String name = '';
    Widget preview;

    if (item is BackgroundItem) {
      final BackgroundItem bg = item as BackgroundItem;
      name = ShopRegistry.resolveName(bg.id, locale);
      if (bg.isImage) {
        preview = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(bg.assetPath!, fit: BoxFit.cover),
        );
      } else {
        preview = Container(
          decoration: BoxDecoration(
            color: bg.color,
            gradient: bg.gradient,
            borderRadius: BorderRadius.circular(8),
          ),
        );
      }
    } else if (item is CardBackItem) {
      final CardBackItem cb = item as CardBackItem;
      name = ShopRegistry.resolveName(cb.id, locale);
      if (cb.isImage) {
        preview = ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(cb.assetPath!, fit: BoxFit.cover),
        );
      } else {
        preview = Container(
          decoration: BoxDecoration(
            color: cb.color,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              '\u2660',
              style: TextStyle(
                color: cb.colorPattern,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
    } else if (item is FigureItem) {
      final FigureItem fig = item as FigureItem;
      name = ShopRegistry.resolveName(fig.id, locale);
      preview = ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(fig.previewPath, fit: BoxFit.cover),
      );
    } else {
      preview = const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFFD54F), width: 2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: preview,
          ),
        ),
        const SizedBox(height: 4),
        SizedBox(
          width: 80,
          child: Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppTheme.secondaryText,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
