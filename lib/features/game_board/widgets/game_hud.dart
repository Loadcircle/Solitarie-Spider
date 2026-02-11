import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../l10n/generated/app_localizations.dart';

class GameHud extends StatelessWidget {
  const GameHud({
    super.key,
    required this.score,
    required this.moves,
    required this.elapsed,
    required this.completedSequences,
    this.onPauseTap,
  });

  final int score;
  final int moves;
  final Duration elapsed;
  final int completedSequences;
  final VoidCallback? onPauseTap;

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      color: AppTheme.hudBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStat(l10n.score, '$score'),
          _buildStat(l10n.moves, '$moves'),
          _buildStat(l10n.time, _formatDuration(elapsed)),
          _buildStat(l10n.sequences, '$completedSequences/8'),
          if (onPauseTap != null)
            IconButton(
              icon: Icon(Icons.pause, color: AppTheme.primaryText),
              onPressed: onPauseTap,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
