import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/difficulty.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../providers/ranking_provider.dart';

class RankingScreen extends ConsumerWidget {
  const RankingScreen({super.key});

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
    final ranking = ref.watch(rankingProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ranking)),
      body: ranking.isEmpty
          ? Center(
              child: Text(
                l10n.noHistory,
                style: const TextStyle(color: Colors.white70, fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: ranking.length,
              itemBuilder: (context, index) {
                final result = ranking[index];
                final position = index + 1;

                return Card(
                  color: Colors.grey.shade800,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: position <= 3
                          ? Colors.amber
                          : Colors.grey.shade600,
                      child: Text(
                        '#$position',
                        style: TextStyle(
                          color:
                              position <= 3 ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${l10n.score}: ${result.score}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      '${_difficultyLabel(result.difficulty, l10n)} | ${l10n.moves}: ${result.moves} | ${_formatDuration(result.time)}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                    trailing: Icon(
                      result.isWon ? Icons.emoji_events : Icons.close,
                      color: result.isWon ? Colors.amber : Colors.red,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
