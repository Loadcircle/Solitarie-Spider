import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/enums/difficulty.dart';
import '../../l10n/generated/app_localizations.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ListTile(
            title: Text(
              l10n.defaultDifficulty,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              _difficultyLabel(settings.defaultDifficulty, l10n),
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: Text(l10n.defaultDifficulty),
                  children: [
                    for (final d in Difficulty.values)
                      SimpleDialogOption(
                        onPressed: () {
                          notifier.setDefaultDifficulty(d);
                          Navigator.of(ctx).pop();
                        },
                        child: Text(
                          _difficultyLabel(d, l10n),
                          style: TextStyle(
                            fontWeight: d == settings.defaultDifficulty
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          const Divider(color: Colors.white24),
          SwitchListTile(
            title: Text(
              l10n.sound,
              style: const TextStyle(color: Colors.white),
            ),
            value: settings.soundEnabled,
            onChanged: (_) => notifier.toggleSound(),
          ),
          SwitchListTile(
            title: Text(
              l10n.animations,
              style: const TextStyle(color: Colors.white),
            ),
            value: settings.animationsEnabled,
            onChanged: (_) => notifier.toggleAnimations(),
          ),
          SwitchListTile(
            title: Text(
              l10n.confirmBeforeNewGame,
              style: const TextStyle(color: Colors.white),
            ),
            value: settings.confirmNewGame,
            onChanged: (_) => notifier.toggleConfirmNewGame(),
          ),
          const Divider(color: Colors.white24),
          ListTile(
            title: Text(
              l10n.language,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              settings.locale.languageCode == 'en'
                  ? l10n.english
                  : l10n.spanish,
              style: const TextStyle(color: Colors.white70),
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.white54),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: Text(l10n.language),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        notifier.setLocale(const Locale('en'));
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        l10n.english,
                        style: TextStyle(
                          fontWeight: settings.locale.languageCode == 'en'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        notifier.setLocale(const Locale('es'));
                        Navigator.of(ctx).pop();
                      },
                      child: Text(
                        l10n.spanish,
                        style: TextStyle(
                          fontWeight: settings.locale.languageCode == 'es'
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
