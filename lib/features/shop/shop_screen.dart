import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import '../../core/theme/gradient_background.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/shop_item.dart';
import '../../providers/settings_provider.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shop)),
      body: GradientBackground(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _SectionHeader(title: l10n.backgrounds),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.0,
              children: [
                for (final option in BackgroundOption.values)
                  _BackgroundTile(
                    option: option,
                    isSelected: settings.selectedBackground == option,
                    l10n: l10n,
                    onTap: () {
                      ref.read(settingsProvider.notifier).setBackground(option);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 24),
            _SectionHeader(title: l10n.cardBacks),
            const SizedBox(height: 8),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.75,
              children: [
                for (final option in CardBackOption.values)
                  _CardBackTile(
                    option: option,
                    isSelected: settings.selectedCardBack == option,
                    l10n: l10n,
                    onTap: () {
                      ref.read(settingsProvider.notifier).setCardBack(option);
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
    required this.l10n,
    required this.onTap,
  });

  final BackgroundOption option;
  final bool isSelected;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  String _getDisplayName() {
    switch (option) {
      case BackgroundOption.defaultGreen:
        return l10n.bgDefaultGreen;
      case BackgroundOption.darkEmerald:
        return l10n.bgDarkEmerald;
      case BackgroundOption.image1:
        return l10n.bgImage1;
      case BackgroundOption.image2:
        return l10n.bgImage2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryButton : Colors.white24,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 9 : 11),
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (option.isImage)
                Image.asset(option.assetPath!, fit: BoxFit.cover)
              else if (option.isGradient)
                Container(
                  decoration: BoxDecoration(gradient: option.gradient),
                )
              else
                Container(color: option.color),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  child: Text(
                    _getDisplayName(),
                    style: TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButton,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
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
    required this.l10n,
    required this.onTap,
  });

  final CardBackOption option;
  final bool isSelected;
  final AppLocalizations l10n;
  final VoidCallback onTap;

  String _getDisplayName() {
    switch (option) {
      case CardBackOption.defaultBlue:
        return l10n.cbDefaultBlue;
      case CardBackOption.darkRed:
        return l10n.cbDarkRed;
      case CardBackOption.image1:
        return l10n.cbImage1;
      case CardBackOption.image2:
        return l10n.cbImage2;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryButton : Colors.white24,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 9 : 11),
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
                      margin: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
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
                            fontSize: 32,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 8,
                  ),
                  child: Text(
                    _getDisplayName(),
                    style: TextStyle(
                      color: AppTheme.primaryText,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 6,
                  right: 6,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryButton,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 16,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
