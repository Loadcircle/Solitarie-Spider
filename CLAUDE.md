# Spider Solitaire - Flutter App

## Project Overview
A Spider Solitaire card game built with Flutter, targeting Android (mobile-first). Features 1/2/4 suit difficulty modes, drag & drop card movement, scoring system, and bilingual support (EN/ES).

## Architecture

### Pure Dart Game Logic (`lib/game/`)
- Zero Flutter imports - testable with `dart test`
- `GameEngine` is the facade that orchestrates all operations
- `DeckBuilder`, `MoveValidator`, `SequenceDetector`, `Scoring` are pure logic classes

### State Management
- **flutter_riverpod** (^2.6.1) with StateNotifier pattern
- `gameProvider` - central game state (nullable, null = no active game)
- `timerProvider` - separate to avoid unnecessary rebuilds
- `settingsProvider` - user preferences including locale
- `historyProvider` / `rankingProvider` - in-memory game results

### Immutable State
- `GameState`, `PlayingCard`, etc. use `copyWith` pattern
- Every game operation returns a new state object

### Card Identity
- Unique IDs: `"suit_rank_deckIndex"` (needed because 2 decks = duplicate suit+rank combos)

## Key Directories
```
lib/core/          # Enums, constants, theme
lib/game/          # Pure Dart game logic (ZERO Flutter imports)
lib/models/        # Data models
lib/providers/     # Riverpod providers
lib/features/      # Screen-based feature folders
lib/routes/        # Named route definitions
lib/l10n/          # ARB files + generated localizations
```

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

## Conventions
- i18n: All user-facing strings via `AppLocalizations` (lib/l10n/generated/)
- ARB files: `app_en.arb` (English), `app_es.arb` (Spanish)
- l10n output: `lib/l10n/generated/` (non-synthetic package)
- Navigation: Simple push/pop with named routes (no GoRouter)
- Theme: Dark theme with green felt background
