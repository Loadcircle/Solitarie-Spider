import 'package:flutter/material.dart';
import '../../../core/ads/banner_ad_widget.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../l10n/generated/app_localizations.dart';

class PauseDialog extends StatelessWidget {
  const PauseDialog({
    super.key,
    required this.onContinue,
    required this.onBackToHome,
  });

  final VoidCallback onContinue;
  final VoidCallback onBackToHome;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Dialog(
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
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.pause_circle_filled,
                size: 48, color: Color(0xFF4CAF50)),
            const SizedBox(height: 16),
            Text(
              l10n.gamePaused,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryText,
              ),
            ),
            const SizedBox(height: 24),
            AppButton(
              icon: Icons.play_arrow,
              label: l10n.continueGame,
              onPressed: onContinue,
              isPrimary: true,
            ),
            const SizedBox(height: 10),
            AppButton(
              icon: Icons.home,
              label: l10n.backToHome,
              onPressed: onBackToHome,
              isPrimary: false,
            ),
            const SizedBox(height: 16),
            const BannerAdWidget(),
          ],
        ),
      ),
    );
  }
}
