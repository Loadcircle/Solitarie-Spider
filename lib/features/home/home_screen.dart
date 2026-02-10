import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../routes/app_router.dart';
import '../../providers/game_provider.dart';
import '../../providers/settings_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  void _onNewGame(BuildContext context, WidgetRef ref) {
    final gameState = ref.read(gameProvider);
    final settings = ref.read(settingsProvider);
    final hasActiveGame = gameState != null && gameState.isStarted && !gameState.isWon;

    if (hasActiveGame && settings.confirmNewGame) {
      final l10n = AppLocalizations.of(context)!;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.confirmNewGame),
          content: Text(l10n.confirmNewGameMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.pushNamed(context, AppRouter.newGame);
              },
              child: Text(l10n.confirm),
            ),
          ],
        ),
      );
    } else {
      Navigator.pushNamed(context, AppRouter.newGame);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final gameState = ref.watch(gameProvider);
    final hasActiveGame = gameState != null && gameState.isStarted && !gameState.isWon;

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.appTitle,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                '♠ ♥ ♦ ♣',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white70,
                    ),
              ),
              const SizedBox(height: 48),
              if (hasActiveGame)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, AppRouter.gameBoard),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.continueGame),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(220, 56),
                    ),
                  ),
                ),
              ElevatedButton.icon(
                onPressed: () => _onNewGame(context, ref),
                icon: const Icon(Icons.add),
                label: Text(l10n.newGame),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 56),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.history),
                icon: const Icon(Icons.history),
                label: Text(l10n.history),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 56),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.ranking),
                icon: const Icon(Icons.leaderboard),
                label: Text(l10n.ranking),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 56),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    Navigator.pushNamed(context, AppRouter.settings),
                icon: const Icon(Icons.settings),
                label: Text(l10n.settings),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(220, 56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
