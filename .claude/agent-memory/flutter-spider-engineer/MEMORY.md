# FlutterSpiderEngineer Memory

## Project
- Spider Solitaire Flutter app, Android-first
- Flutter 3.38.7, Dart 3.10.7
- Working directory: D:\Trabajo\Programas\my_solitarie\my_solitarie

## Key Patterns

### l10n
- Use `output-dir: lib/l10n/generated` in l10n.yaml (synthetic-package is deprecated)
- Import from `'../../l10n/generated/app_localizations.dart'` (relative path)

### Riverpod
- flutter_riverpod 2.6.1 with StateNotifier pattern (not newer Notifier API)
- Central providers: gameProvider, settingsProvider, timerProvider, historyProvider, rankingProvider, playerProvider

### Dart
- Cannot use `name` as enum field (conflicts with built-in `.name`), use `displayName`
- `strict_top_level_inference` requires explicit types on method parameters
- Use `.withValues(alpha: x)` instead of deprecated `.withOpacity(x)`

### IAP
- Package: `in_app_purchase: ^3.2.0`
- Purchase stream: `InAppPurchase.instance.purchaseStream` (NOT `purchaseUpdatedStream`)
- IAPService singleton at: `lib/core/iap/iap_service.dart`
- Product ID for remove ads: `remove_ads`
- adsRemoved persisted via SharedPreferences key `adsRemoved` in SettingsNotifier

### Ads
- `AdBannerWidget` at `lib/core/ads/ad_banner_widget.dart` wraps BannerAdWidget and checks `adsRemoved`
- All screens use `const AdBannerWidget()` (not inline SafeArea+BannerAdWidget)
- Block interstitial load/show when `settings.adsRemoved == true`

## Key File Paths
- `lib/core/iap/iap_service.dart` — IAP singleton
- `lib/core/ads/ad_banner_widget.dart` — respects adsRemoved flag
- `lib/core/ads/ad_service.dart` — AdService singleton
- `lib/models/settings_state.dart` — includes `adsRemoved: bool`
- `lib/providers/settings_provider.dart` — setAdsRemoved() persists to SharedPreferences

## Architecture Notes
- See architecture.md for full folder structure
- SettingsScreen converted to ConsumerStatefulWidget (was ConsumerWidget) to hold IAP product state
- HomeScreen initializes IAPService in initState, disposes in dispose
