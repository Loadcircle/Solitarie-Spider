# Spider Solitaire

Spider Solitaire card game built with Flutter, targeting Android (mobile-first).

## Features

- 1 / 2 / 4 suit difficulty modes
- Drag & drop card movement with tap-to-auto-move
- Scoring system (500 base - 1/move + 100/sequence + 500 win bonus)
- Per-difficulty stats (fastest time, win streak, best score)
- Calendar history with trophy markers
- Shop: customizable backgrounds and card backs
- Trilingual support: English, Spanish, Portuguese
- Sound effects and music

## Tech Stack

- **Flutter** 3.38.7 / **Dart** 3.10.7
- **State management**: flutter_riverpod 2.6.1 (StateNotifier pattern)
- **Localization**: Flutter gen-l10n (EN/ES/PT)
- **Calendar**: table_calendar
- **Audio**: audioplayers
- **Preferences**: shared_preferences

## Project Structure

```
lib/
  core/enums/         # Difficulty, Suit, Rank enums
  core/theme/         # AppTheme, GradientBackground
  core/widgets/       # Shared widgets (AppButton)
  game/               # Pure Dart game logic (zero Flutter imports)
  models/             # Data models (GameState, PlayingCard, etc.)
  providers/          # Riverpod providers
  features/           # Screen-based feature folders
  routes/             # Named route definitions
  l10n/               # ARB files + generated localizations
```

## Commands

```bash
# Install dependencies
flutter pub get

# Run on connected device/emulator
flutter run

# Static analysis (must be zero warnings)
flutter analyze

# Run unit tests
flutter test

# Regenerate localization files
flutter gen-l10n

# Generate app icons
dart run flutter_launcher_icons
```

## Build APK

```bash
# Debug APK (for testing)
flutter build apk --debug

# Release APK (optimized, unsigned)
flutter build apk --release

# Release APK split per ABI (smaller size, recommended)
flutter build apk --split-per-abi
```

Output will be at `build/app/outputs/flutter-apk/`.

- `--split-per-abi` generates separate APKs for `arm64-v8a`, `armeabi-v7a`, and `x86_64` (~15-20 MB each instead of one ~50 MB universal APK).
- For most modern phones, use the `arm64-v8a` variant.

## Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`
