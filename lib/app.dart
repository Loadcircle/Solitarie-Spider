import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/generated/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/shop_registry.dart';
import 'core/constants/xp_config.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'models/player_state.dart';
import 'providers/player_provider.dart';
import 'providers/settings_provider.dart';
import 'routes/app_router.dart';

class SpiderSolitaireApp extends ConsumerStatefulWidget {
  const SpiderSolitaireApp({super.key});

  @override
  ConsumerState<SpiderSolitaireApp> createState() =>
      _SpiderSolitaireAppState();
}

class _SpiderSolitaireAppState extends ConsumerState<SpiderSolitaireApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initNotifications();
  }

  Future<void> _initNotifications() async {
    final NotificationService ns = NotificationService.instance;
    await ns.requestPermission();
    // Initial daily streak schedule will happen once l10n context is available
    // (see _syncStreakSchedule called from build via addPostFrameCallback).
  }

  bool _hasSyncedStreak = false;

  void _syncStreakSchedule(AppLocalizations l10n) {
    if (_hasSyncedStreak) return;
    _hasSyncedStreak = true;

    final settings = ref.read(settingsProvider);
    if (settings.streakReminderEnabled) {
      NotificationService.instance.scheduleDailyStreak(
        title: l10n.streakReminderTitle,
        body: l10n.streakReminderBody,
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _onAppBackgrounded();
    } else if (state == AppLifecycleState.resumed) {
      NotificationService.instance.cancelRewardProximity();
    }
  }

  void _onAppBackgrounded() {
    final settings = ref.read(settingsProvider);
    if (!settings.rewardAlertEnabled) return;

    final PlayerState player = ref.read(playerProvider);
    final nextReward = ShopRegistry.nextRewardAfter(player.level);
    if (nextReward == null) return;

    // Estimate XP from winning 1 game at default difficulty with average
    // performance (~10min, ~120 moves).
    final int estimatedXp = XpConfig.calculateXp(
      difficulty: settings.defaultDifficulty,
      time: const Duration(minutes: 10),
      moves: 120,
    );

    // XP needed to reach the next reward level from current position
    int xpNeeded = 0;
    int lvl = player.level;
    int xpInLevel = player.currentXp;
    while (lvl < nextReward.level) {
      final int xpForNext = XpConfig.xpForLevel(lvl + 1);
      xpNeeded += xpForNext - xpInLevel;
      xpInLevel = 0;
      lvl++;
    }

    if (estimatedXp >= xpNeeded) {
      // Use stored locale strings — we can't access l10n from lifecycle callback,
      // so we use hardcoded fallbacks based on locale.
      final String locale = settings.locale.languageCode;
      final String title = _rewardTitle(locale);
      final String body = _rewardBody(locale);

      NotificationService.instance.scheduleRewardProximity(
        title: title,
        body: body,
      );
    }
  }

  String _rewardTitle(String locale) {
    switch (locale) {
      case 'es':
        return '\u{1F381} \u{00A1}Ya casi!';
      case 'pt':
        return '\u{1F381} Quase l\u{00E1}!';
      default:
        return '\u{1F381} Almost there!';
    }
  }

  String _rewardBody(String locale) {
    switch (locale) {
      case 'es':
        return 'Te falta solo una victoria para desbloquear';
      case 'pt':
        return 'Falta apenas uma vit\u{00F3}ria para desbloquear';
      default:
        return 'One win away from unlocking a reward';
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: 'Spider Solitaire',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: settings.locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      onGenerateRoute: AppRouter.onGenerateRoute,
      initialRoute: AppRouter.home,
      builder: (BuildContext context, Widget? child) {
        // Sync streak schedule once l10n is available.
        final AppLocalizations? l10n = AppLocalizations.of(context);
        if (l10n != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _syncStreakSchedule(l10n);
          });
        }
        return child!;
      },
    );
  }
}
