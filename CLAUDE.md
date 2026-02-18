# Spider Solitaire - Flutter App

## Project Overview
Spider Solitaire card game built with Flutter, targeting Android (mobile-first). Features 1/2/4 suit difficulty modes, drag & drop card movement, scoring system, and trilingual support (EN/ES/PT).

## Architecture

### Pure Dart Game Logic (`lib/game/`)
- Zero Flutter imports - testable with `dart test`
- `GameEngine` is the facade that orchestrates all operations
- `DeckBuilder`, `MoveValidator`, `SequenceDetector`, `Scoring` are pure logic classes

### State Management
- **flutter_riverpod** (^2.6.1) with StateNotifier pattern (not newer Notifier API)
- `gameProvider` - central game state (nullable, null = no active game)
- `timerProvider` - separate to avoid unnecessary rebuilds
- `settingsProvider` - user preferences including locale
- `historyProvider` / `rankingProvider` - in-memory game results

### Immutable State
- `GameState`, `PlayingCard`, etc. use `copyWith` pattern
- Every game operation returns a new state object

## Key Directories
```
lib/core/enums/       # Difficulty, Suit, Rank enums
lib/core/theme/       # AppTheme, GradientBackground
lib/core/widgets/     # Shared widgets (AppButton)
lib/core/ads/         # Ad system (AdService singleton + BannerAdWidget)
lib/core/services/    # App-wide services (NotificationService, SoundService)
lib/game/             # Pure Dart game logic (ZERO Flutter imports)
lib/models/           # Data models (GameState, SettingsState, PlayingCard)
lib/providers/        # Riverpod providers
lib/features/         # Screen-based feature folders
lib/routes/           # Named route definitions
lib/l10n/             # ARB files + generated localizations
```

## Design System

### Background
- **All screens** use `GradientBackground` (radial vignette: `#1E5E2A` center → `#0A1A0E` edge)
- **HomeScreen** has its own identical radial vignette via `Stack` (doesn't use `GradientBackground`)
- **GameBoardScreen** is excluded — it has its own shop-customizable background system

### Buttons — `AppButton` (`lib/core/widgets/app_button.dart`)
- Standard button across the entire app. Parameters: `icon?`, `label`, `onPressed`, `isPrimary`
- **Primary**: green gradient `#4CAF50` → `#2E7D32`, border `#5CAF60`
- **Secondary**: charcoal gradient `#3A4A3E` → `#2A3530`, border `#4A5A4E`
- Height 54, borderRadius 14, w600 text, Material ripple

### Dialogs
- All dialogs use `Dialog` + inner `Container` with gradient background:
  - `LinearGradient` top→bottom: `#1F3A24` → `#0F1E12`
  - Border: `#2A4A2E`, borderRadius 20, boxShadow black45
- Buttons inside dialogs: `AppButton` pairs (primary + secondary)

### AppBar
- Background: `#0A1A0E` (matches vignette edge for cohesion)

## Game Rules
- **Deal**: Columns 1-4 get 6 cards (5 down + 1 up), columns 5-10 get 5 cards (4 down + 1 up)
- **Pickup**: Same-suit descending sequence only
- **Drop**: Descending rank (any suit) or empty column
- **Sequence**: K→A same suit auto-removed, +100 points
- **Stock deal**: All 10 columns must have ≥1 card
- **Win**: 8 completed sequences
- **Scoring**: 500 initial - 1/move + 100/sequence + 500 win bonus

## Commands
- `flutter analyze` - Static analysis (must be zero warnings)
- `flutter test` - Run all unit tests
- `flutter gen-l10n` - Regenerate localization files
- `flutter run` - Run on connected device/emulator

## Ads System (`lib/core/ads/`)

- `google_mobile_ads: ^7.0.0` — initialized in `main.dart` via `MobileAds.instance.initialize()`
- `AdService` singleton (`ad_service.dart`) — centralizes all ad types. Currently using **Google test IDs**. None load or show automatically; call `load*()` to preload, `show*()` to display.
- `BannerAdWidget` (`banner_ad_widget.dart`) — self-contained widget, manages own lifecycle. Accepts optional `AdSize` (defaults to `AdSize.banner`). Use anywhere in the widget tree.
- Ad types available:
  - **Banner** — `BannerAdWidget()` — persistent in-screen strip
  - **Interstitial** — full-screen static, between games / on return to home
  - **Rewarded** — full-screen video, user earns reward (undo, hint, etc.)
  - **Rewarded Interstitial** — like rewarded but skippable, lower friction
  - **App Open** — shown when app returns from background
- AdMob App ID in `AndroidManifest.xml` as `com.google.android.gms.ads.APPLICATION_ID`

## Conventions
- i18n: All user-facing strings via `AppLocalizations` (lib/l10n/generated/)
- ARB files: `app_en.arb`, `app_es.arb`, `app_pt.arb`
- l10n config: `output-dir: lib/l10n/generated` in l10n.yaml
- Navigation: Simple push/pop with named routes (no GoRouter)
- Card IDs: `"suit_rank_deckIndex"` (2 decks = duplicate suit+rank combos)
