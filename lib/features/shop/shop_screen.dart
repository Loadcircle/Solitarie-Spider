import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/shop_registry.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/gradient_background.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/shop_item.dart';
import '../../providers/player_provider.dart';
import '../../providers/settings_provider.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);
    final playerNotifier = ref.watch(playerProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shop)),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader(title: l10n.backgrounds),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 9 / 16,
              children: [
                for (final option in ShopRegistry.backgrounds)
                  _BackgroundTile(
                    option: option,
                    isSelected: settings.selectedBackground == option,
                    isUnlocked: playerNotifier.isItemUnlocked(option),
                    requiredLevel: ShopRegistry.requiredLevelFor(option),
                    onTap: () {
                      if (playerNotifier.isItemUnlocked(option)) {
                        ref
                            .read(settingsProvider.notifier)
                            .setBackground(option);
                      } else {
                        final int lvl =
                            ShopRegistry.requiredLevelFor(option) ?? 0;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.unlocksAtLevel(lvl))),
                        );
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.cardBacks),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 2.5 / 3.5,
              children: [
                for (final option in ShopRegistry.cardBacks)
                  _CardBackTile(
                    option: option,
                    isSelected: settings.selectedCardBack == option,
                    isUnlocked: playerNotifier.isItemUnlocked(option),
                    requiredLevel: ShopRegistry.requiredLevelFor(option),
                    onTap: () {
                      if (playerNotifier.isItemUnlocked(option)) {
                        ref
                            .read(settingsProvider.notifier)
                            .setCardBack(option);
                      } else {
                        final int lvl =
                            ShopRegistry.requiredLevelFor(option) ?? 0;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.unlocksAtLevel(lvl))),
                        );
                      }
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.figures),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.0,
              children: [
                for (final option in ShopRegistry.figures)
                  _FigureTile(
                    option: option,
                    isSelected: settings.selectedFigure == option,
                    isUnlocked: playerNotifier.isItemUnlocked(option),
                    requiredLevel: ShopRegistry.requiredLevelFor(option),
                    onTap: () {
                      if (playerNotifier.isItemUnlocked(option)) {
                        ref
                            .read(settingsProvider.notifier)
                            .setFigure(option);
                      } else {
                        final int lvl =
                            ShopRegistry.requiredLevelFor(option) ?? 0;
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.unlocksAtLevel(lvl))),
                        );
                      }
                    },
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppTheme.primaryText,
      ),
    );
  }
}

class _BackgroundTile extends StatelessWidget {
  const _BackgroundTile({
    required this.option,
    required this.isSelected,
    required this.isUnlocked,
    required this.requiredLevel,
    required this.onTap,
  });

  final BackgroundItem option;
  final bool isSelected;
  final bool isUnlocked;
  final int? requiredLevel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected && isUnlocked
                ? AppTheme.primaryButton
                : Colors.white24,
            width: isSelected && isUnlocked ? 2.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(isSelected && isUnlocked ? 7.5 : 9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (option.isImage)
                Image.asset(option.assetPath!, fit: BoxFit.fill)
              else if (option.isGradient)
                Container(
                  decoration: BoxDecoration(gradient: option.gradient),
                )
              else
                Container(color: option.color),
              _TileNameLabel(
                name: ShopRegistry.resolveName(option.id, Localizations.localeOf(context).languageCode),
              ),
              if (isSelected && isUnlocked) const _TileCheckMark(),
              if (!isUnlocked) _LockedOverlay(requiredLevel: requiredLevel),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardBackTile extends StatelessWidget {
  const _CardBackTile({
    required this.option,
    required this.isSelected,
    required this.isUnlocked,
    required this.requiredLevel,
    required this.onTap,
  });

  final CardBackItem option;
  final bool isSelected;
  final bool isUnlocked;
  final int? requiredLevel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected && isUnlocked
                ? AppTheme.primaryButton
                : Colors.white24,
            width: isSelected && isUnlocked ? 2.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(isSelected && isUnlocked ? 7.5 : 9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (option.isImage)
                Image.asset(option.assetPath!, fit: BoxFit.cover)
              else
                Container(
                  color: option.color,
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      margin: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: option.colorPattern!,
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '\u2660',
                          style: TextStyle(
                            color: option.colorPattern,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              _TileNameLabel(
                name: ShopRegistry.resolveName(option.id, Localizations.localeOf(context).languageCode),
              ),
              if (isSelected && isUnlocked) const _TileCheckMark(),
              if (!isUnlocked) _LockedOverlay(requiredLevel: requiredLevel),
            ],
          ),
        ),
      ),
    );
  }
}

class _FigureTile extends StatelessWidget {
  const _FigureTile({
    required this.option,
    required this.isSelected,
    required this.isUnlocked,
    required this.requiredLevel,
    required this.onTap,
  });

  final FigureItem option;
  final bool isSelected;
  final bool isUnlocked;
  final int? requiredLevel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected && isUnlocked
                ? AppTheme.primaryButton
                : Colors.white24,
            width: isSelected && isUnlocked ? 2.5 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(isSelected && isUnlocked ? 7.5 : 9),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(option.previewPath, fit: BoxFit.cover),
              _TileNameLabel(
                name: ShopRegistry.resolveName(option.id, Localizations.localeOf(context).languageCode),
              ),
              if (isSelected && isUnlocked) const _TileCheckMark(),
              if (!isUnlocked) _LockedOverlay(requiredLevel: requiredLevel),
            ],
          ),
        ),
      ),
    );
  }
}

class _TileNameLabel extends StatelessWidget {
  const _TileNameLabel({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.black54,
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        child: Text(
          name,
          style: TextStyle(
            color: AppTheme.primaryText,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

class _TileCheckMark extends StatelessWidget {
  const _TileCheckMark();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 4,
      right: 4,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.primaryButton,
          shape: BoxShape.circle,
        ),
        padding: const EdgeInsets.all(3),
        child: const Icon(
          Icons.check,
          color: Colors.black,
          size: 12,
        ),
      ),
    );
  }
}

class _LockedOverlay extends StatelessWidget {
  const _LockedOverlay({required this.requiredLevel});

  final int? requiredLevel;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.6),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock, color: Colors.white70, size: 24),
            if (requiredLevel != null) ...[
              const SizedBox(height: 2),
              Text(
                'Lvl $requiredLevel',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
