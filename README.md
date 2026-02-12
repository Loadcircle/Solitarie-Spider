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

## Level & XP System

Players earn XP by winning games. XP depends on difficulty and efficiency (time/moves). Leveling up unlocks cosmetic items (backgrounds and card backs) in the shop.

All configuration is in **`lib/core/constants/xp_config.dart`**:

### Base XP per difficulty (only on win)

```dart
static const int baseXpOneSuit = 50;
static const int baseXpTwoSuits = 100;
static const int baseXpFourSuits = 200;
```

### Multipliers (1.0x – 1.5x each)

```dart
// Time: <= 5 min = 1.5x, >= 20 min = 1.0x
static const double timeTargetMinutes = 5.0;
static const double timeSlowMinutes = 20.0;
static const double maxTimeMultiplier = 1.5;

// Moves: <= 80 = 1.5x, >= 200 = 1.0x
static const int movesTarget = 80;
static const int movesSlow = 200;
static const double maxMovesMultiplier = 1.5;
```

### Number of levels

```dart
static const int maxLevel = 30;
```

### XP required per level

```dart
// level * 100 (level 2 = 100xp, level 10 = 900xp, level 30 = 2900xp)
static int xpForLevel(int level) => level * 100;
```

### Shop items & rewards

All shop items (backgrounds and card backs) are defined in a single file: **`assets/shop_items.json`**.

To add a new item:
1. Drop the image in `assets/images/backgrounds/` or `assets/images/cards/`
2. Add an entry to the JSON array — that's it

```json
{
  "id": "my_new_background",
  "unlockLevel": 8,
  "assetPath": "assets/images/backgrounds/my_image.png",
  "en": "My Background",
  "es": "Mi Fondo",
  "pt": "Meu Fundo"
}
```

- Array order = display order in the shop
- `unlockLevel`: level required to unlock (omit for free from level 1)
- Translations are inline (no ARB files needed for shop items)

### Asset dimensions

| Asset type | Recommended size | Aspect ratio | Format |
|---|---|---|---|
| **Backgrounds** | 1080 x 1920 px | 9:16 (portrait) | PNG or JPG |
| **Card backs** | 500 x 700 px | 5:7 | PNG |

- **Backgrounds** are displayed with `BoxFit.cover` (fills the screen, may crop edges). 1080x1920 covers FHD phones; larger is fine but adds APK size.
- **Card backs** use the app's card aspect ratio of 2.5:3.5 (= 5:7). Cards render at ~30-40px wide on screen, so 500x700 is more than enough. Keep file size small since the image repeats for every face-down card.

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
