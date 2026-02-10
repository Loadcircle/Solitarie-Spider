import 'package:flutter/material.dart';
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

    return AlertDialog(
      title: Text(
        l10n.youWin,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🏆', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(l10n.congratulations, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(
            l10n.finalScore(score),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(l10n.totalMoves(moves)),
          Text(l10n.totalTime(_formatDuration(elapsed))),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onBackToHome,
          child: Text(l10n.backToHome),
        ),
        ElevatedButton(
          onPressed: onPlayAgain,
          child: Text(l10n.playAgain),
        ),
      ],
    );
  }
}
