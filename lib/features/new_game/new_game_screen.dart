import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/difficulty.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/gradient_background.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/settings_provider.dart';
import '../../routes/app_router.dart';

class NewGameScreen extends ConsumerWidget {
  const NewGameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.newGame)),
      body: GradientBackground(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 32),
              Text(
                l10n.difficulty,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppTheme.primaryText,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              for (final difficulty in Difficulty.values) ...[
                _DifficultyCard(
                  difficulty: difficulty,
                  isSelected: difficulty == settings.defaultDifficulty,
                  l10n: l10n,
                  onTap: () {
                    Navigator.pushReplacementNamed(
                      context,
                      AppRouter.gameBoard,
                      arguments: difficulty,
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  const _DifficultyCard({
    required this.difficulty,
    required this.isSelected,
    required this.l10n,
    required this.onTap,
  });

  final Difficulty difficulty;
  final bool isSelected;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  String _difficultyLabel() {
    switch (difficulty) {
      case Difficulty.oneSuit:
        return '${l10n.oneSuit} - ${l10n.easy}';
      case Difficulty.twoSuits:
        return '${l10n.twoSuits} - ${l10n.medium}';
      case Difficulty.fourSuits:
        return '${l10n.fourSuits} - ${l10n.hard}';
    }
  }

  String _suitSymbols() {
    switch (difficulty) {
      case Difficulty.oneSuit:
        return '♠';
      case Difficulty.twoSuits:
        return '♠ ♥';
      case Difficulty.fourSuits:
        return '♠ ♥ ♦ ♣';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? AppTheme.primaryButton : AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF5CAF60)
              : const Color(0xFF4A5A4E),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              child: Row(
                children: [
                  Opacity(
                    opacity: isSelected ? 1.0 : 0.45,
                    child: Text(
                      _suitSymbols(),
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _difficultyLabel(),
                          style: TextStyle(
                            color: isSelected
                                ? AppTheme.primaryText
                                : AppTheme.secondaryText,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.play_arrow,
                    color: isSelected
                        ? AppTheme.primaryText
                        : AppTheme.secondaryText,
                    size: 32,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
