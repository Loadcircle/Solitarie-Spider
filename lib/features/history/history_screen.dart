import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/difficulty.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/history_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _difficultyLabel(Difficulty d, AppLocalizations l10n) {
    switch (d) {
      case Difficulty.oneSuit:
        return l10n.oneSuit;
      case Difficulty.twoSuits:
        return l10n.twoSuits;
      case Difficulty.fourSuits:
        return l10n.fourSuits;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final history = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: history.isEmpty
          ? Center(
              child: Text(
                l10n.noHistory,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final result = history[history.length - 1 - index];
                return Card(
                  color: Colors.grey.shade800,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      result.isWon ? Icons.emoji_events : Icons.close,
                      color: result.isWon ? Colors.amber : Colors.red,
                      size: 32,
                    ),
                    title: Text(
                      '${_difficultyLabel(result.difficulty, l10n)} - ${result.isWon ? l10n.won : l10n.lost}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '${l10n.score}: ${result.score} | ${l10n.moves}: ${result.moves} | ${_formatDuration(result.time)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Text(
                      '${result.dateTime.day}/${result.dateTime.month}',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
