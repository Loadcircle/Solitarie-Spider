# Spider Solitaire – Technical Overview (MVP)

## 1. Technology Stack

### Core
- **Flutter (Dart)**

### State Management
- **Riverpod** (`flutter_riverpod`)
- In-memory state only (no backend, no persistence for MVP)

### UI & Interaction
- `Stack` + `Positioned` for board layout and card stacking
- `GestureDetector` for drag & drop
- `OverlayEntry` for dragging single cards or card stacks

### Animations
- `AnimationController` + `Tween`
- `AnimatedPositioned` for snap animations
- `Transform` for flips and small visual effects

### Persistence
- Not included in MVP  
  (Future: `shared_preferences` for settings, `Hive` or `Drift` for history)

### Ads
- Not included in MVP  
  (Future: `google_mobile_ads` + UMP consent)

---

## 2. App Pages & Navigation

### Pages (MVP)
- Home
- New Game
- Game Board
- History
- Ranking
- Settings

Navigation is simple and linear (no deep routing required).

---

## 3. Page Definitions

### Home
- New Game
- Continue (only if a game exists in memory)
- History
- Ranking
- Settings

Optional:
- Quick difficulty selector (1 / 2 / 4 suits)

---

### New Game
- Difficulty selection:
  - 1 Suit
  - 2 Suits
  - 4 Suits
- Start Game button

---

### Game Board (Spider Solitaire)

**Layout**
- 10 tableau columns
- Stock pile (remaining deals)
- Top HUD:
  - Score
  - Moves
  - Time
  - Completed sequences

**Interactions**
- Drag & drop card stacks
- Tap stock to deal a new row
- Automatic detection and removal of completed sequences

---

### History
- List of completed games:
  - Date
  - Difficulty
  - Score
  - Time
  - Moves

For MVP, this screen can exist without persistence (session-only or placeholder).

---

### Ranking
- Local ranking (no login)
- Sorted by score

For MVP, this screen can exist without persistence.

---

### Settings
- Default difficulty (1 / 2 / 4 suits)
- Sound on/off
- Animations on/off (or normal / fast)
- Confirm before starting a new game

---

## 4. Game Rules (Spider – MVP)

- 10 tableau columns
- Cards can be moved only if they form a descending sequence
- Completed sequence:
  - King → Ace
  - Same suit
  - Automatically removed from the board
- Difficulty impact:
  - **1 Suit**: all cards share the same suit
  - **2 / 4 Suits**: only same-suit sequences can be completed
- Stock deal:
  - Deals one card to each tableau column

---

## 5. Scoring System (Simple MVP)

- Initial score: **500**
- Each move: **-1**
- Completed sequence (K → A): **+100**
- Game completed bonus: **+500**
- Time penalty (optional): **-1 every 30 seconds**

---

## 6. MVP Scope Summary

Included in MVP:
- Full Spider Solitaire gameplay
- 1 / 2 / 4 suit modes
- Drag & drop with animations
- Scoring, moves, time
- Win detection and completion screen
- Home, Game, Settings, History, Ranking screens