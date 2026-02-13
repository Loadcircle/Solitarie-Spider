import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/difficulty.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/gradient_background.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/difficulty_stats.dart';
import '../../providers/ranking_provider.dart';

class RankingScreen extends ConsumerStatefulWidget {
  const RankingScreen({super.key});

  @override
  ConsumerState<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends ConsumerState<RankingScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final int minutes = d.inMinutes.remainder(60);
    final int seconds = d.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Map<Difficulty, DifficultyStats> stats = ref.watch(rankingProvider);

    final List<Difficulty> tabs = [
      Difficulty.oneSuit,
      Difficulty.twoSuits,
      Difficulty.fourSuits,
    ];

    final List<String> tabLabels = [
      l10n.oneSuit,
      l10n.twoSuits,
      l10n.fourSuits,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.ranking),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFF4CAF50),
          labelColor: AppTheme.primaryText,
          unselectedLabelColor: AppTheme.secondaryText,
          tabs: tabLabels.map((String label) => Tab(text: label)).toList(),
        ),
      ),
      body: GradientBackground(
        child: TabBarView(
          controller: _tabController,
          children: tabs.map((Difficulty difficulty) {
            final DifficultyStats? diffStats = stats[difficulty];

            if (diffStats == null) {
              return Center(
                child: Text(
                  l10n.noStats,
                  style: TextStyle(
                    color: AppTheme.secondaryText,
                    fontSize: 18,
                  ),
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StatCard(
                  icon: Icons.timer,
                  label: l10n.fastestTime,
                  value: diffStats.fastestTime != null
                      ? _formatDuration(diffStats.fastestTime!)
                      : '--:--',
                ),
                const SizedBox(height: 8),
                _StatCard(
                  icon: Icons.schedule,
                  label: l10n.averageTime,
                  value: _formatDuration(diffStats.averageTime),
                ),
                const SizedBox(height: 8),
                _StatCard(
                  icon: Icons.local_fire_department,
                  label: l10n.longestWinStreak,
                  value: '${diffStats.longestWinStreak}',
                ),
                const SizedBox(height: 8),
                _StatCard(
                  icon: Icons.emoji_events,
                  label: l10n.bestScore,
                  value: '${diffStats.bestScore}',
                ),
                const SizedBox(height: 8),
                _StatCard(
                  icon: Icons.percent,
                  label: l10n.winRate,
                  value: '${(diffStats.winRate * 100).toStringAsFixed(1)}%',
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.amber, size: 28),
        title: Text(
          label,
          style: TextStyle(
            color: AppTheme.secondaryText,
            fontSize: 14,
          ),
        ),
        trailing: Text(
          value,
          style: TextStyle(
            color: AppTheme.primaryText,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
