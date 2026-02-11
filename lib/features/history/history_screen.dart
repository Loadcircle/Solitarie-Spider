import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../core/enums/difficulty.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/gradient_background.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/game_result.dart';
import '../../providers/history_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  String _formatDuration(Duration d) {
    final int minutes = d.inMinutes.remainder(60);
    final int seconds = d.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
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

  List<GameResult> _getEventsForDay(
    DateTime day,
    Map<DateTime, List<GameResult>> historyByDate,
  ) {
    final DateTime key = DateTime(day.year, day.month, day.day);
    return historyByDate[key] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations l10n = AppLocalizations.of(context)!;
    final Map<DateTime, List<GameResult>> historyByDate =
        ref.watch(historyByDateProvider);

    final List<GameResult> selectedEvents = _selectedDay != null
        ? _getEventsForDay(_selectedDay!, historyByDate)
        : [];

    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: GradientBackground(
        child: Column(
          children: [
            TableCalendar<GameResult>(
              firstDay: DateTime(2024),
              lastDay: DateTime.now().add(const Duration(days: 365)),
              focusedDay: _focusedDay,
              selectedDayPredicate: (DateTime day) =>
                  isSameDay(_selectedDay, day),
              onDaySelected: (DateTime selectedDay, DateTime focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onPageChanged: (DateTime focusedDay) {
                _focusedDay = focusedDay;
              },
              eventLoader: (DateTime day) =>
                  _getEventsForDay(day, historyByDate),
              calendarBuilders: CalendarBuilders<GameResult>(
                markerBuilder: (BuildContext context, DateTime day,
                    List<GameResult> events) {
                  if (events.isEmpty) return null;
                  return Positioned(
                    bottom: 1,
                    child: Icon(
                      Icons.emoji_events,
                      size: 16,
                      color: Colors.amber,
                    ),
                  );
                },
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: TextStyle(
                  color: AppTheme.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                leftChevronIcon:
                    Icon(Icons.chevron_left, color: AppTheme.primaryText),
                rightChevronIcon:
                    Icon(Icons.chevron_right, color: AppTheme.primaryText),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: AppTheme.primaryText),
                weekendTextStyle: TextStyle(color: AppTheme.primaryText),
                outsideTextStyle: TextStyle(color: AppTheme.disabledText),
                todayDecoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: const Color(0xFF4CAF50),
                  shape: BoxShape.circle,
                ),
                markerDecoration: BoxDecoration(
                  color: Colors.amber,
                  shape: BoxShape.circle,
                ),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: AppTheme.secondaryText),
                weekendStyle: TextStyle(color: AppTheme.secondaryText),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: selectedEvents.isEmpty
                  ? Center(
                      child: Text(
                        _selectedDay != null
                            ? l10n.noGamesOnDay
                            : l10n.noHistory,
                        style: TextStyle(
                          color: AppTheme.secondaryText,
                          fontSize: 16,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      itemCount: selectedEvents.length,
                      itemBuilder: (BuildContext context, int index) {
                        final GameResult result = selectedEvents[index];
                        return Card(
                          color: AppTheme.surface,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              result.isWon
                                  ? Icons.emoji_events
                                  : Icons.close,
                              color:
                                  result.isWon ? Colors.amber : Colors.red,
                              size: 32,
                            ),
                            title: Text(
                              '${_difficultyLabel(result.difficulty, l10n)} - ${result.isWon ? l10n.won : l10n.lost}',
                              style: TextStyle(
                                color: AppTheme.primaryText,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              '${l10n.score}: ${result.score} | ${l10n.moves}: ${result.moves} | ${_formatDuration(result.time)}',
                              style:
                                  TextStyle(color: AppTheme.secondaryText),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
