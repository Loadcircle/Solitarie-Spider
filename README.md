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

## Changing Texts (i18n)

All user-facing strings are localized in 3 ARB files inside `lib/l10n/`:

| File | Language |
|------|----------|
| `app_en.arb` | English |
| `app_es.arb` | Spanish |
| `app_pt.arb` | Portuguese |

Each ARB is a JSON with `"key": "text"` pairs. The key is the same across all 3 files, only the text changes.

**To change an existing text:**

1. Find the key in the 3 ARB files and update the text:
   ```json
   // app_en.arb
   "shop": "Appearance"
   // app_es.arb
   "shop": "Apariencia"
   // app_pt.arb
   "shop": "Aparência"
   ```
2. Run `flutter gen-l10n` to regenerate the Dart classes.
3. Done. No Dart code changes needed if the key stays the same.

**To add a new text:**

1. Add the same key with its translation to all 3 ARB files:
   ```json
   "myNewKey": "Hello"        // app_en.arb
   "myNewKey": "Hola"         // app_es.arb
   "myNewKey": "Olá"          // app_pt.arb
   ```
2. Run `flutter gen-l10n`.
3. Use it in Dart code:
   ```dart
   final l10n = AppLocalizations.of(context)!;
   Text(l10n.myNewKey)
   ```

**To add a text with parameters:**

1. Use `{paramName}` in the text and add a `@key` metadata entry:
   ```json
   "greeting": "Hello {name}!",
   "@greeting": {
     "placeholders": {
       "name": { "type": "String" }
     }
   }
   ```
2. Run `flutter gen-l10n`.
3. Use in Dart: `l10n.greeting('World')`.

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
