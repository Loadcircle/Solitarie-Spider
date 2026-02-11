import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/generated/app_localizations.dart';

class WinDialog extends StatelessWidget {
  const WinDialog({
    super.key,
    required this.score,
    required this.moves,
    required this.elapsed,
    required this.onPlayAgain,
    required this.onBackToHome,
  });

  final int score;
  final int moves;
  final Duration elapsed;
  final VoidCallback onPlayAgain;
  final VoidCallback onBackToHome;

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
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
            Text(
              l10n.youWin,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 12),
            const Text('🏆', style: TextStyle(fontSize: 64)),
            const SizedBox(height: 12),
            Text(
              l10n.congratulations,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.secondaryText),
            ),
            const SizedBox(height: 16),
            Text(
              l10n.finalScore(score),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.totalMoves(moves),
              style: TextStyle(color: AppTheme.secondaryText),
            ),
            Text(
              l10n.totalTime(_formatDuration(elapsed)),
              style: TextStyle(color: AppTheme.secondaryText),
            ),
            const SizedBox(height: 24),
            AppButton(
              icon: Icons.replay,
              label: l10n.playAgain,
              onPressed: onPlayAgain,
              isPrimary: true,
            ),
            const SizedBox(height: 10),
            AppButton(
              icon: Icons.home,
              label: l10n.backToHome,
              onPressed: onBackToHome,
              isPrimary: false,
            ),
          ],
        ),
      ),
    );
  }
}
