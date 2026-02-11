import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../routes/app_router.dart';
import '../../providers/game_provider.dart';
import '../../providers/settings_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _hasShownLanguageDialog = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _maybeShowLanguagePicker();
  }

  void _maybeShowLanguagePicker() {
    if (_hasShownLanguageDialog) return;
    final settings = ref.read(settingsProvider);
    if (settings.hasSelectedLanguage) return;

    _hasShownLanguageDialog = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _showLanguagePickerDialog();
    });
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
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo_clean.png',
                      width: 200,
                      height: 200,
                    ),
                    const SizedBox(height: 40),
                    if (hasActiveGame) ...[
                      AppButton(
                        icon: Icons.play_arrow,
                        label: l10n.continueGame,
                        onPressed: () =>
                            Navigator.pushNamed(context, AppRouter.gameBoard),
                        isPrimary: true,
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
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
