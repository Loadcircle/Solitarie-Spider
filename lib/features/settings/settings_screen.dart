import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/difficulty.dart';
import '../../core/services/notification_service.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/gradient_background.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/settings_state.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

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

  String _languageLabel(String code, AppLocalizations l10n) {
    switch (code) {
      case 'es':
        return l10n.spanish;
      case 'pt':
        return l10n.portuguese;
      default:
        return l10n.english;
    }
  }

  void _showDifficultyDialog(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
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
                  color: Colors.black45, blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.defaultDifficulty,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              for (final d in Difficulty.values) ...[
                _dialogOption(
                  ctx,
                  label: _difficultyLabel(d, l10n),
                  isSelected: d == settings.defaultDifficulty,
                  onTap: () {
                    notifier.setDefaultDifficulty(d);
                    Navigator.of(ctx).pop();
                  },
                ),
                if (d != Difficulty.values.last)
                  Divider(color: const Color(0xFF2A4A2E), height: 1),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref,
      AppLocalizations l10n, SettingsState settings) {
    final notifier = ref.read(settingsProvider.notifier);
    final languages = [
      ('en', l10n.english),
      ('es', l10n.spanish),
      ('pt', l10n.portuguese),
    ];
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
                  color: Colors.black45, blurRadius: 12, offset: Offset(0, 4)),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.language,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryText,
                ),
              ),
              const SizedBox(height: 16),
              for (var i = 0; i < languages.length; i++) ...[
                _dialogOption(
                  ctx,
                  label: languages[i].$2,
                  isSelected: settings.locale.languageCode == languages[i].$1,
                  onTap: () {
                    notifier.setLocale(Locale(languages[i].$1));
                    Navigator.of(ctx).pop();
                  },
                ),
                if (i < languages.length - 1)
                  Divider(color: const Color(0xFF2A4A2E), height: 1),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogOption(
    BuildContext ctx, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          color: AppTheme.primaryText,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: Color(0xFF4CAF50), size: 20)
          : null,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: GradientBackground(
        child: ListView(
          children: [
            const SizedBox(height: 8),
            ListTile(
              title: Text(
                l10n.defaultDifficulty,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                _difficultyLabel(settings.defaultDifficulty, l10n),
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              trailing: Icon(Icons.chevron_right, color: AppTheme.disabledText),
              onTap: () =>
                  _showDifficultyDialog(context, ref, l10n, settings),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                l10n.sound,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              value: settings.soundEnabled,
              onChanged: (_) => notifier.toggleSound(),
            ),
            SwitchListTile(
              title: Text(
                l10n.music,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              value: settings.musicEnabled,
              onChanged: (_) => notifier.toggleMusic(),
            ),
            SwitchListTile(
              title: Text(
                l10n.confirmBeforeNewGame,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              value: settings.confirmNewGame,
              onChanged: (_) => notifier.toggleConfirmNewGame(),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: Text(
                l10n.allowDealWithEmptyColumns,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                l10n.allowDealWithEmptyColumnsDescription,
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              value: settings.allowDealWithEmptyColumns,
              onChanged: (_) => notifier.toggleAllowDealWithEmptyColumns(),
            ),
            SwitchListTile(
              title: Text(
                l10n.highlightMovable,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                l10n.highlightMovableDescription,
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              value: settings.highlightMovable,
              onChanged: (_) => notifier.toggleHighlightMovable(),
            ),
            SwitchListTile(
              title: Text(
                l10n.tapToAutoMove,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                l10n.tapToAutoMoveDescription,
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              value: settings.tapToAutoMove,
              onChanged: (_) => notifier.toggleTapToAutoMove(),
            ),
            SwitchListTile(
              title: Text(
                l10n.undoEnabled,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                l10n.undoEnabledDescription,
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              value: settings.undoEnabled,
              onChanged: (_) => notifier.toggleUndo(),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                l10n.language,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                _languageLabel(settings.locale.languageCode, l10n),
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              trailing: Icon(Icons.chevron_right, color: AppTheme.disabledText),
              onTap: () =>
                  _showLanguageDialog(context, ref, l10n, settings),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                l10n.notifications,
                style: TextStyle(
                  color: AppTheme.secondaryText,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 4),
            SwitchListTile(
              title: Text(
                l10n.streakReminder,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                l10n.streakReminderDescription,
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              value: settings.streakReminderEnabled,
              onChanged: (_) => notifier.toggleStreakReminder(
                title: l10n.streakReminderTitle,
                body: l10n.streakReminderBody,
              ),
            ),
            SwitchListTile(
              title: Text(
                l10n.rewardAlert,
                style: TextStyle(color: AppTheme.primaryText),
              ),
              subtitle: Text(
                l10n.rewardAlertDescription,
                style: TextStyle(color: AppTheme.secondaryText),
              ),
              value: settings.rewardAlertEnabled,
              onChanged: (_) => notifier.toggleRewardAlert(),
            ),
            if (kDebugMode) ...[
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'DEBUG',
                  style: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              ListTile(
                leading: Icon(Icons.notifications_active,
                    color: Colors.orange.shade300),
                title: Text(
                  'Test streak notification (now)',
                  style: TextStyle(color: AppTheme.primaryText),
                ),
                onTap: () {
                  NotificationService.instance.showNow(
                    id: 9001,
                    title: l10n.streakReminderTitle,
                    body: l10n.streakReminderBody,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Streak notification fired!')),
                  );
                },
              ),
              ListTile(
                leading:
                    Icon(Icons.card_giftcard, color: Colors.orange.shade300),
                title: Text(
                  'Test reward notification (now)',
                  style: TextStyle(color: AppTheme.primaryText),
                ),
                onTap: () {
                  NotificationService.instance.showNow(
                    id: 9002,
                    title: l10n.rewardProximityTitle,
                    body: l10n.rewardProximityBody,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Reward notification fired!')),
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
