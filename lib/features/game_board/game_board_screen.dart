import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/card_dimensions.dart';
import '../../core/enums/difficulty.dart';
import '../../game/move_validator.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/game_result.dart';
import '../../models/game_state.dart';
import '../../models/playing_card.dart';
import '../../models/shop_item.dart';
import '../../providers/game_provider.dart';
import '../../models/settings_state.dart';
import '../../providers/settings_provider.dart';
import '../../providers/timer_provider.dart';
import '../../providers/history_provider.dart';
import '../../core/services/notification_service.dart';
import '../../core/services/sound_service.dart';
import '../../providers/sound_service_provider.dart';
import '../../core/constants/xp_config.dart';
import '../../providers/player_provider.dart';
import '../../routes/app_router.dart';
import 'widgets/tableau_area.dart';
import 'widgets/stock_pile_widget.dart';
import 'widgets/completed_area.dart';
import 'widgets/card_widget.dart';
import 'widgets/game_hud.dart';
import 'widgets/win_dialog.dart';
import 'widgets/lose_dialog.dart';
import 'widgets/pause_dialog.dart';
import '../../game/game_over_detector.dart';
import '../../core/theme/app_theme.dart';

class GameBoardScreen extends ConsumerStatefulWidget {
  const GameBoardScreen({super.key, this.difficulty});

  final Difficulty? difficulty;

  @override
  ConsumerState<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends ConsumerState<GameBoardScreen>
    with WidgetsBindingObserver {
  bool _hasShownWinDialog = false;
  bool _hasShownLoseDialog = false;
  bool _initialized = false;
  ({int col, int card})? _shakeTarget;

  // Deal animation
  final GlobalKey _stockPileKey = GlobalKey();
  final List<GlobalKey> _columnKeys =
      List.generate(10, (_) => GlobalKey());
  bool _isAnimatingDeal = false;
  OverlayEntry? _dealOverlay;

  // Sequence animation
  final GlobalKey _completedAreaKey = GlobalKey();
  final List<GlobalKey> _slotKeys = List.generate(8, (_) => GlobalKey());
  bool _isAnimatingSequence = false;
  OverlayEntry? _sequenceOverlay;

  // Intro animation
  bool _isAnimatingIntro = false;
  OverlayEntry? _introOverlay;

  // Auto-move animation
  OverlayEntry? _autoMoveOverlay;
  bool _isAnimatingAutoMove = false;
  int? _autoMoveHideColumn;
  int? _autoMoveHideFromIndex;

  // Sound/music
  late final SoundService _soundService;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _soundService = ref.read(soundServiceProvider);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGame();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    final gameState = ref.read(gameProvider);
    if (gameState == null || gameState.isWon) return;

    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      ref.read(timerProvider.notifier).stop();
      _soundService.stopBackgroundMusic();
    } else if (state == AppLifecycleState.resumed) {
      ref.read(timerProvider.notifier).resume();
      final settings = ref.read(settingsProvider);
      if (settings.musicEnabled) {
        _soundService.startBackgroundMusic();
      }
    }
  }

  void _initGame() {
    final gameState = ref.read(gameProvider);
    final bool isNewGame = widget.difficulty != null || gameState == null;

    if (isNewGame) {
      final difficulty = widget.difficulty ?? Difficulty.oneSuit;
      ref.read(gameProvider.notifier).startNewGame(difficulty);
      ref.read(timerProvider.notifier).start();
      _hasShownWinDialog = false;
      NotificationService.instance.markPlayedToday();

      // Launch intro animation; _initialized deferred to onComplete
      _isAnimatingIntro = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _startIntroAnimation();
      });
    } else {
      ref.read(timerProvider.notifier).resume();
      _hasShownLoseDialog = false;
      setState(() => _initialized = true);
    }

    // Start background music if enabled
    final settings = ref.read(settingsProvider);
    if (settings.musicEnabled) {
      _soundService.startBackgroundMusic();
    }
    _soundService.preload();
  }

  void _startIntroAnimation() {
    // Capture stock pile position
    final stockBox =
        _stockPileKey.currentContext?.findRenderObject() as RenderBox?;
    if (stockBox == null) {
      // Fallback: skip animation
      if (mounted) setState(() { _isAnimatingIntro = false; _initialized = true; });
      return;
    }
    final stockPos = stockBox.localToGlobal(Offset.zero);
    final stockSize = stockBox.size;

    final screenSize = MediaQuery.of(context).size;
    final screenCenter = Offset(
      screenSize.width / 2,
      screenSize.height / 2,
    );

    // Use the normal card width from layout
    final cardWidth = CardDimensions.cardWidth(screenSize.width);

    final settings = ref.read(settingsProvider);
    final cbOption = settings.selectedCardBack;

    // Target: center of the stock pile's first card
    final targetPosition = Offset(
      stockPos.dx + stockSize.width - cardWidth,
      stockPos.dy,
    );

    _introOverlay = OverlayEntry(
      builder: (BuildContext context) => _IntroCardBack(
        screenCenter: screenCenter,
        targetPosition: targetPosition,
        cardWidth: cardWidth,
        cardBackOption: cbOption,
        onComplete: () {
          _introOverlay?.remove();
          _introOverlay = null;
          if (mounted) {
            setState(() {
              _isAnimatingIntro = false;
              _initialized = true;
            });
          }
        },
      ),
    );

    Overlay.of(context).insert(_introOverlay!);
  }

  void _checkGameOver() {
    final gameState = ref.read(gameProvider);
    if (gameState == null || gameState.isWon || _hasShownLoseDialog) return;
    final settings = ref.read(settingsProvider);
    if (GameOverDetector.isGameOver(gameState,
        allowDealWithEmptyColumns: settings.allowDealWithEmptyColumns)) {
      _hasShownLoseDialog = true;
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _showLoseDialog();
      });
    }
  }

  void _playSound(GameSound sound) {
    if (!ref.read(settingsProvider).soundEnabled) return;
    ref.read(soundServiceProvider).play(sound);
  }

  void _onAcceptDrop(int toColumn, int fromColumn, int fromCardIndex) {
    final stateBefore = ref.read(gameProvider);
    ref.read(gameProvider.notifier).moveCards(
          fromColumn: fromColumn,
          cardIndex: fromCardIndex,
          toColumn: toColumn,
        );
    final stateAfter = ref.read(gameProvider);
    if (stateAfter != null && stateAfter != stateBefore) {
      // Check if a sequence was completed by this move
      if (stateBefore != null &&
          stateAfter.completedSequences > stateBefore.completedSequences) {
        _playSound(GameSound.sequenceComplete);
        _triggerSequenceAnimation(stateAfter, stateBefore.completedSequences);
      } else {
        _playSound(GameSound.cardMove);
      }
      _checkGameOver();
    }
  }

  void _onDealFromStock() {
    if (_isAnimatingDeal || _isAnimatingIntro) return;

    final l10n = AppLocalizations.of(context)!;
    final state = ref.read(gameProvider);
    final settings = ref.read(settingsProvider);
    if (state == null) return;

    if (state.stock.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.stockEmpty)),
      );
      return;
    }

    // Check all columns have at least one card (unless setting overrides)
    if (!settings.allowDealWithEmptyColumns) {
      final hasEmptyColumn = state.tableau.any((col) => col.isEmpty);
      if (hasEmptyColumn) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.allColumnsMustHaveCards)),
        );
        return;
      }
    }

    // Capture stock pile position before dealing
    final stockBox =
        _stockPileKey.currentContext?.findRenderObject() as RenderBox?;
    final stockPos = stockBox?.localToGlobal(Offset.zero);
    final stockSize = stockBox?.size;

    // Perform the deal
    ref.read(gameProvider.notifier).dealFromStock(
          allowEmptyColumns: settings.allowDealWithEmptyColumns,
        );
    _playSound(GameSound.cardDeal);

    // Get the dealt cards (last card of each column in new state)
    final newState = ref.read(gameProvider);
    if (newState == null || stockPos == null || stockSize == null) return;

    // Check for sequence completion after deal
    if (newState.removedSequences.isNotEmpty) {
      final prevCompleted = state.completedSequences;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerSequenceAnimation(newState, prevCompleted);
      });
    }

    final dealtCards = <PlayingCard>[];
    for (var i = 0; i < 10; i++) {
      if (newState.tableau[i].isNotEmpty) {
        dealtCards.add(newState.tableau[i].last);
      }
    }

    // Start flying animation
    setState(() => _isAnimatingDeal = true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startDealAnimation(stockPos, stockSize, dealtCards);
    });

    _checkGameOver();
  }

  void _startDealAnimation(
    Offset stockPos,
    Size stockSize,
    List<PlayingCard> dealtCards,
  ) {
    // Get target positions from column render boxes
    final targets = <Offset>[];
    double? cardWidth;

    for (var i = 0; i < _columnKeys.length; i++) {
      final colBox =
          _columnKeys[i].currentContext?.findRenderObject() as RenderBox?;
      if (colBox != null) {
        final colPos = colBox.localToGlobal(Offset.zero);
        cardWidth ??= colBox.size.width;
        final cHeight = CardDimensions.cardHeight(colBox.size.width);
        // Target = bottom of column minus card height, excluding the extra drop-target padding
        final targetY = colPos.dy + colBox.size.height - cHeight - cHeight * 0.5;
        targets.add(Offset(colPos.dx, targetY));
      } else {
        targets.add(stockPos);
      }
    }

    cardWidth ??= 30.0;

    final figureItem = ref.read(settingsProvider).selectedFigure;
    _dealOverlay = OverlayEntry(
      builder: (context) => _DealFlyingCards(
        stockPosition: Offset(
          stockPos.dx + stockSize.width - cardWidth!,
          stockPos.dy,
        ),
        targetPositions: targets,
        cards: dealtCards,
        cardWidth: cardWidth,
        figureItem: figureItem,
        onComplete: () {
          _dealOverlay?.remove();
          _dealOverlay = null;
          if (mounted) {
            setState(() => _isAnimatingDeal = false);
          }
        },
      ),
    );

    Overlay.of(context).insert(_dealOverlay!);
  }

  void _triggerSequenceAnimation(GameState stateAfter, int prevCompleted) {
    if (_isAnimatingSequence) return;
    if (stateAfter.removedSequences.isEmpty) return;

    setState(() => _isAnimatingSequence = true);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSequenceAnimation(stateAfter, prevCompleted);
    });
  }

  void _startSequenceAnimation(GameState stateAfter, int prevCompleted) {
    // Determine target slot index (first new slot that was just filled)
    final targetSlotIndex = prevCompleted.clamp(0, 7);
    final slotBox =
        _slotKeys[targetSlotIndex].currentContext?.findRenderObject()
            as RenderBox?;
    if (slotBox == null) {
      setState(() => _isAnimatingSequence = false);
      return;
    }
    final targetPos = slotBox.localToGlobal(Offset.zero);

    // Compute source positions for each removed sequence
    final allSourcePositions = <List<Offset>>[];
    final allCards = <List<PlayingCard>>[];
    double? cardWidth;

    for (final seq in stateAfter.removedSequences) {
      final colBox =
          _columnKeys[seq.column].currentContext?.findRenderObject()
              as RenderBox?;
      if (colBox == null) continue;

      final colPos = colBox.localToGlobal(Offset.zero);
      cardWidth ??= colBox.size.width;
      final cHeight = CardDimensions.cardHeight(colBox.size.width);
      final faceUpOverlap = CardDimensions.faceUpOverlap(cHeight);
      final faceDownOverlap = CardDimensions.faceDownOverlap(cHeight);

      // Column has already shrunk (sequence removed). Compute where the
      // removed cards WERE by walking from top using remaining cards as offset.
      final remainingCards = stateAfter.tableau[seq.column];
      double seqStartY = colPos.dy;
      for (final PlayingCard c in remainingCards) {
        seqStartY += c.isFaceUp ? faceUpOverlap : faceDownOverlap;
      }

      // Each removed card (all face-up) was stacked with faceUpOverlap
      final sourcePositions = <Offset>[];
      for (var i = 0; i < seq.cards.length; i++) {
        sourcePositions.add(Offset(colPos.dx, seqStartY + i * faceUpOverlap));
      }
      allSourcePositions.add(sourcePositions);
      allCards.add(seq.cards);
    }

    if (allCards.isEmpty || cardWidth == null) {
      setState(() => _isAnimatingSequence = false);
      return;
    }

    // Flatten all cards and positions
    final flatCards = <PlayingCard>[];
    final flatSources = <Offset>[];
    for (var i = 0; i < allCards.length; i++) {
      flatCards.addAll(allCards[i]);
      flatSources.addAll(allSourcePositions[i]);
    }

    final seqFigureItem = ref.read(settingsProvider).selectedFigure;
    _sequenceOverlay = OverlayEntry(
      builder: (context) => _SequenceFlyingCards(
        sourcePositions: flatSources,
        targetPosition: targetPos,
        cards: flatCards,
        cardWidth: cardWidth!,
        figureItem: seqFigureItem,
        onComplete: () {
          _sequenceOverlay?.remove();
          _sequenceOverlay = null;
          if (mounted) {
            setState(() => _isAnimatingSequence = false);
          }
        },
      ),
    );

    Overlay.of(context).insert(_sequenceOverlay!);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _introOverlay?.remove();
    _introOverlay = null;
    _dealOverlay?.remove();
    _dealOverlay = null;
    _sequenceOverlay?.remove();
    _sequenceOverlay = null;
    _autoMoveOverlay?.remove();
    _autoMoveOverlay = null;
    _soundService.stopBackgroundMusic();
    super.dispose();
  }

  void _recordAbandon() {
    final state = ref.read(gameProvider);
    if (state == null || !state.isStarted || state.isWon) return;
    ref.read(historyProvider.notifier).addResult(GameResult(
          dateTime: DateTime.now(),
          difficulty: state.difficulty,
          score: state.score,
          time: state.elapsed,
          moves: state.moveCount,
          isWon: false,
        ));
  }

  void _onUndo() {
    if (_isAnimatingDeal || _isAnimatingIntro || _isAnimatingAutoMove || _isAnimatingSequence) return;
    final gameState = ref.read(gameProvider);
    if (gameState == null || !gameState.canUndo) return;
    ref.read(gameProvider.notifier).undo();
    _playSound(GameSound.cardMove);
  }

  void _onPause() {
    final gameState = ref.read(gameProvider);
    if (gameState == null || gameState.isWon) return;

    ref.read(timerProvider.notifier).stop();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PauseDialog(
        onContinue: () {
          Navigator.of(ctx).pop();
          ref.read(timerProvider.notifier).resume();
        },
        onBackToHome: () {
          _recordAbandon();
          Navigator.of(ctx).pop();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
        },
      ),
    ).then((_) {
      // If dialog dismissed via Android back button, resume timer
      final gameState = ref.read(gameProvider);
      if (gameState != null && !gameState.isWon) {
        ref.read(timerProvider.notifier).resume();
      }
    });
  }

  void _onCardTap(int columnIndex, int cardIndex) {
    final settings = ref.read(settingsProvider);
    if (!settings.tapToAutoMove) return;
    if (_isAnimatingAutoMove || _isAnimatingIntro) return;

    final gameState = ref.read(gameProvider);
    if (gameState == null || gameState.isWon) return;

    final targetColumn = MoveValidator.findBestTarget(
      tableau: gameState.tableau,
      fromColumn: columnIndex,
      cardIndex: cardIndex,
    );

    if (targetColumn != null) {
      // Snapshot source positions before move
      final cardsToMove = gameState.tableau[columnIndex].sublist(cardIndex);
      final sourceColBox =
          _columnKeys[columnIndex].currentContext?.findRenderObject()
              as RenderBox?;

      final stateBefore = ref.read(gameProvider);
      ref.read(gameProvider.notifier).moveCards(
            fromColumn: columnIndex,
            cardIndex: cardIndex,
            toColumn: targetColumn,
          );
      final stateAfter = ref.read(gameProvider);

      final bool isSequence = stateAfter != null &&
          stateBefore != null &&
          stateAfter.completedSequences > stateBefore.completedSequences;

      if (isSequence) {
        _playSound(GameSound.sequenceComplete);
        _triggerSequenceAnimation(stateAfter, stateBefore.completedSequences);
      } else {
        _playSound(GameSound.cardMove);
      }

      // Animate flying cards from source to target column
      if (sourceColBox != null && stateAfter != null) {
        _startAutoMoveAnimation(
          sourceColBox: sourceColBox,
          fromColumn: columnIndex,
          fromCardIndex: cardIndex,
          toColumn: targetColumn,
          cards: cardsToMove,
          stateBefore: stateBefore!,
        );
      }
      _checkGameOver();
    } else {
      _playSound(GameSound.invalidMove);
      // Trigger shake animation
      setState(() {
        _shakeTarget = (col: columnIndex, card: cardIndex);
      });
      Future.delayed(const Duration(milliseconds: 450), () {
        if (mounted) {
          setState(() => _shakeTarget = null);
        }
      });
    }
  }

  void _startAutoMoveAnimation({
    required RenderBox sourceColBox,
    required int fromColumn,
    required int fromCardIndex,
    required int toColumn,
    required List<PlayingCard> cards,
    required GameState stateBefore,
  }) {
    final sourceColPos = sourceColBox.localToGlobal(Offset.zero);
    final cardWidth = sourceColBox.size.width;
    final cardHeight = CardDimensions.cardHeight(cardWidth);
    final faceUpOverlap = CardDimensions.faceUpOverlap(cardHeight);
    final faceDownOverlap = CardDimensions.faceDownOverlap(cardHeight);

    // Compute source Y offset for the card at fromCardIndex
    double sourceTopOffset = 0;
    for (var i = 0; i < fromCardIndex; i++) {
      sourceTopOffset += stateBefore.tableau[fromColumn][i].isFaceUp
          ? faceUpOverlap
          : faceDownOverlap;
    }

    // Source positions for each card in the stack
    final sourcePositions = <Offset>[];
    for (var i = 0; i < cards.length; i++) {
      sourcePositions.add(Offset(
        sourceColPos.dx,
        sourceColPos.dy + sourceTopOffset + i * faceUpOverlap,
      ));
    }

    // Get target column position after the move
    final targetColBox =
        _columnKeys[toColumn].currentContext?.findRenderObject() as RenderBox?;
    if (targetColBox == null) return;

    final targetColPos = targetColBox.localToGlobal(Offset.zero);
    // Cards are now at the end of the target column — compute where they sit
    final stateAfter = ref.read(gameProvider);
    if (stateAfter == null) return;

    final targetCards = stateAfter.tableau[toColumn];
    // The moved cards start at targetCards.length - cards.length
    final moveStartIndex = targetCards.length - cards.length;
    double targetTopOffset = 0;
    for (var i = 0; i < moveStartIndex; i++) {
      targetTopOffset += targetCards[i].isFaceUp
          ? faceUpOverlap
          : faceDownOverlap;
    }

    final targetPositions = <Offset>[];
    for (var i = 0; i < cards.length; i++) {
      targetPositions.add(Offset(
        targetColPos.dx,
        targetColPos.dy + targetTopOffset + i * faceUpOverlap,
      ));
    }

    // Hide moved cards in target column during animation
    setState(() {
      _isAnimatingAutoMove = true;
      _autoMoveHideColumn = toColumn;
      _autoMoveHideFromIndex = moveStartIndex;
    });

    final autoFigureItem = ref.read(settingsProvider).selectedFigure;
    _autoMoveOverlay = OverlayEntry(
      builder: (context) => _AutoMoveFlyingCards(
        sourcePositions: sourcePositions,
        targetPositions: targetPositions,
        cards: cards,
        cardWidth: cardWidth,
        figureItem: autoFigureItem,
        onComplete: () {
          _autoMoveOverlay?.remove();
          _autoMoveOverlay = null;
          if (mounted) {
            setState(() {
              _isAnimatingAutoMove = false;
              _autoMoveHideColumn = null;
              _autoMoveHideFromIndex = null;
            });
          }
        },
      ),
    );

    Overlay.of(context).insert(_autoMoveOverlay!);
  }

  void _showWinDialog() {
    final state = ref.read(gameProvider);
    if (state == null) return;

    ref.read(timerProvider.notifier).stop();
    _playSound(GameSound.win);

    // Record game result
    ref.read(historyProvider.notifier).addResult(GameResult(
          dateTime: DateTime.now(),
          difficulty: state.difficulty,
          score: state.score,
          time: state.elapsed,
          moves: state.moveCount,
          isWon: true,
        ));

    // Calculate and grant XP
    final int xpEarned = XpConfig.calculateXp(
      difficulty: state.difficulty,
      time: state.elapsed,
      moves: state.moveCount,
    );
    final int levelBefore = ref.read(playerProvider).level;
    ref.read(playerProvider.notifier).addXp(xpEarned);
    final int levelAfter = ref.read(playerProvider).level;
    final bool leveledUp = levelAfter > levelBefore;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WinDialog(
        score: state.score,
        moves: state.moveCount,
        elapsed: state.elapsed,
        xpEarned: xpEarned,
        leveledUp: leveledUp,
        newLevel: levelAfter,
        onPlayAgain: () {
          Navigator.of(ctx).pop();
          ref
              .read(gameProvider.notifier)
              .startNewGame(state.difficulty);
          ref.read(timerProvider.notifier).start();
          _hasShownWinDialog = false;
        },
        onBackToHome: () {
          Navigator.of(ctx).pop();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
        },
      ),
    );
  }

  void _showLoseDialog() {
    final state = ref.read(gameProvider);
    if (state == null) return;

    ref.read(timerProvider.notifier).stop();
    _playSound(GameSound.lose);

    ref.read(historyProvider.notifier).addResult(GameResult(
          dateTime: DateTime.now(),
          difficulty: state.difficulty,
          score: state.score,
          time: state.elapsed,
          moves: state.moveCount,
          isWon: false,
        ));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LoseDialog(
        score: state.score,
        moves: state.moveCount,
        elapsed: state.elapsed,
        onPlayAgain: () {
          Navigator.of(ctx).pop();
          ref
              .read(gameProvider.notifier)
              .startNewGame(state.difficulty);
          ref.read(timerProvider.notifier).start();
          _hasShownLoseDialog = false;
        },
        onBackToHome: () {
          Navigator.of(ctx).pop();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(AppRouter.home, (route) => false);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final elapsed = ref.watch(timerProvider);
    final settings = ref.watch(settingsProvider);

    // React to music toggle during gameplay
    ref.listen<bool>(
      settingsProvider.select((SettingsState s) => s.musicEnabled),
      (bool? previous, bool next) {
        if (next) {
          _soundService.startBackgroundMusic();
        } else {
          _soundService.stopBackgroundMusic();
        }
      },
    );

    if (gameState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Check for win (only after _initGame has run)
    if (_initialized && gameState.isWon && !_hasShownWinDialog) {
      _hasShownWinDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWinDialog();
      });
    }

    final BackgroundItem bgOption = settings.selectedBackground;
    final CardBackItem cbOption = settings.selectedCardBack;

    Widget bodyContent = LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = CardDimensions.cardWidth(constraints.maxWidth);
        return Column(
          children: [
            GameHud(
              score: gameState.score,
              moves: gameState.moveCount,
              elapsed: elapsed,
              completedSequences: gameState.completedSequences,
              onPauseTap: gameState.isWon ? null : _onPause,
            ),
            _buildInfoBar(gameState, cbOption),
            Expanded(
              child: SingleChildScrollView(
                child: TableauArea(
                  tableau: gameState.tableau,
                  highlightMovable: settings.highlightMovable,
                  onAcceptDrop: _onAcceptDrop,
                  onCardTap: settings.tapToAutoMove ? _onCardTap : null,
                  shakeTarget: _shakeTarget,
                  hideLastCard: _isAnimatingDeal,
                  columnKeys: _columnKeys,
                  hideCardsInColumn: _autoMoveHideColumn,
                  hideCardsFromIndex: _autoMoveHideFromIndex,
                  cardBackOption: cbOption,
                  figureItem: settings.selectedFigure,
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (settings.undoEnabled)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12, bottom: 4),
                      child: _UndoButton(
                        canUndo: gameState.canUndo && !gameState.isWon,
                        onPressed: _onUndo,
                      ),
                    ),
                  ),
                CompletedArea(
                  key: _completedAreaKey,
                  completedSequences: gameState.completedSequences,
                  cardWidth: cardWidth,
                  slotKeys: _slotKeys,
                ),
              ],
            ),
          ],
        );
      },
    );

    Widget safeBody;
    if (bgOption.isImage) {
      safeBody = SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(bgOption.assetPath!, fit: BoxFit.fill),
            ),
            bodyContent,
          ],
        ),
      );
    } else if (bgOption.isGradient) {
      safeBody = SafeArea(
        child: Container(
          decoration: BoxDecoration(gradient: bgOption.gradient),
          child: bodyContent,
        ),
      );
    } else {
      safeBody = SafeArea(child: bodyContent);
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          _recordAbandon();
          ref.read(timerProvider.notifier).stop();
        }
      },
      child: Scaffold(
        backgroundColor: bgOption.isImage ? Colors.black : bgOption.color,
        body: safeBody,
      ),
    );
  }

  Widget _buildInfoBar(GameState gameState, CardBackItem cbOption) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = CardDimensions.cardWidth(constraints.maxWidth);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          color: AppTheme.hudBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              StockPileWidget(
                key: _stockPileKey,
                dealsRemaining: gameState.stockDealsRemaining,
                cardWidth: cardWidth,
                onTap: _onDealFromStock,
                cardBackOption: cbOption,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _DealFlyingCards extends StatefulWidget {
  const _DealFlyingCards({
    required this.stockPosition,
    required this.targetPositions,
    required this.cards,
    required this.cardWidth,
    required this.onComplete,
    this.figureItem,
  });

  final Offset stockPosition;
  final List<Offset> targetPositions;
  final List<PlayingCard> cards;
  final double cardWidth;
  final VoidCallback onComplete;
  final FigureItem? figureItem;

  @override
  State<_DealFlyingCards> createState() => _DealFlyingCardsState();
}

class _DealFlyingCardsState extends State<_DealFlyingCards>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<Offset>> _positionAnimations;

  static const _cardDuration = Duration(milliseconds: 350);
  static const _staggerDelay = Duration(milliseconds: 40);

  @override
  void initState() {
    super.initState();

    final int count =
        widget.cards.length.clamp(0, widget.targetPositions.length);

    _controllers = List.generate(
      count,
      (int i) => AnimationController(
        duration: _cardDuration,
        vsync: this,
      ),
    );

    _positionAnimations = List.generate(count, (int i) {
      return Tween<Offset>(
        begin: widget.stockPosition,
        end: widget.targetPositions[i],
      ).animate(CurvedAnimation(
        parent: _controllers[i],
        curve: Curves.easeOutCubic,
      ));
    });

    // Start animations with stagger
    for (var i = 0; i < count; i++) {
      Future.delayed(_staggerDelay * i, () {
        if (mounted) _controllers[i].forward();
      });
    }

    // Call onComplete when last animation finishes
    final totalMs =
        _cardDuration.inMilliseconds + _staggerDelay.inMilliseconds * (count - 1);
    Future.delayed(Duration(milliseconds: totalMs + 50), () {
      if (mounted) widget.onComplete();
    });
  }

  @override
  void dispose() {
    for (final AnimationController c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          for (var i = 0; i < _controllers.length; i++)
            AnimatedBuilder(
              animation: _controllers[i],
              builder: (BuildContext context, Widget? child) {
                return Positioned(
                  left: _positionAnimations[i].value.dx,
                  top: _positionAnimations[i].value.dy,
                  child: child!,
                );
              },
              child:
                  CardWidget(card: widget.cards[i], cardWidth: widget.cardWidth, figureItem: widget.figureItem),
            ),
        ],
      ),
    );
  }
}

class _SequenceFlyingCards extends StatefulWidget {
  const _SequenceFlyingCards({
    required this.sourcePositions,
    required this.targetPosition,
    required this.cards,
    required this.cardWidth,
    required this.onComplete,
    this.figureItem,
  });

  final List<Offset> sourcePositions;
  final Offset targetPosition;
  final List<PlayingCard> cards;
  final double cardWidth;
  final VoidCallback onComplete;
  final FigureItem? figureItem;

  @override
  State<_SequenceFlyingCards> createState() => _SequenceFlyingCardsState();
}

class _SequenceFlyingCardsState extends State<_SequenceFlyingCards>
    with TickerProviderStateMixin {
  // Phase 1: collapse cards into a stack
  late final AnimationController _collapseController;
  late final List<Animation<Offset>> _collapseAnimations;

  // Phase 2: fly the stack to the target slot
  late final AnimationController _flyController;
  late final Animation<Offset> _flyAnimation;
  late final Animation<double> _scaleAnimation;

  static const _collapseDuration = Duration(milliseconds: 350);
  static const _flyDuration = Duration(milliseconds: 400);

  late final int _count;
  late final Offset _collapseTarget;

  @override
  void initState() {
    super.initState();

    _count = widget.cards.length.clamp(0, widget.sourcePositions.length);

    // All cards collapse upward to the position of the first card (K)
    _collapseTarget = _count > 0
        ? widget.sourcePositions[0]
        : widget.targetPosition;

    // Phase 1: each card animates to the collapse point
    _collapseController = AnimationController(
      duration: _collapseDuration,
      vsync: this,
    );

    _collapseAnimations = List.generate(_count, (int i) {
      return Tween<Offset>(
        begin: widget.sourcePositions[i],
        end: _collapseTarget,
      ).animate(CurvedAnimation(
        parent: _collapseController,
        curve: Curves.easeInOutCubic,
      ));
    });

    // Phase 2: collapsed stack flies to target slot
    _flyController = AnimationController(
      duration: _flyDuration,
      vsync: this,
    );

    _flyAnimation = Tween<Offset>(
      begin: _collapseTarget,
      end: widget.targetPosition,
    ).animate(CurvedAnimation(
      parent: _flyController,
      curve: Curves.easeInOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _flyController,
      curve: Curves.easeInOut,
    ));

    // Chain: collapse → fly
    _collapseController.forward();
    _collapseController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        _flyController.forward();
      }
    });

    _flyController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _collapseController.dispose();
    _flyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: Listenable.merge([_collapseController, _flyController]),
        builder: (BuildContext context, Widget? child) {
          final bool isFlying = _collapseController.isCompleted;

          if (isFlying) {
            // Phase 2: show the K card flying to target slot
            return Stack(
              children: [
                Positioned(
                  left: _flyAnimation.value.dx,
                  top: _flyAnimation.value.dy,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    alignment: Alignment.topLeft,
                    child: CardWidget(
                      card: widget.cards.first,
                      cardWidth: widget.cardWidth,
                      figureItem: widget.figureItem,
                    ),
                  ),
                ),
              ],
            );
          }

          // Phase 1: all cards collapsing
          return Stack(
            children: [
              for (var i = 0; i < _count; i++)
                Positioned(
                  left: _collapseAnimations[i].value.dx,
                  top: _collapseAnimations[i].value.dy,
                  child: CardWidget(
                    card: widget.cards[i],
                    cardWidth: widget.cardWidth,
                    figureItem: widget.figureItem,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AutoMoveFlyingCards extends StatefulWidget {
  const _AutoMoveFlyingCards({
    required this.sourcePositions,
    required this.targetPositions,
    required this.cards,
    required this.cardWidth,
    required this.onComplete,
    this.figureItem,
  });

  final List<Offset> sourcePositions;
  final List<Offset> targetPositions;
  final List<PlayingCard> cards;
  final double cardWidth;
  final VoidCallback onComplete;
  final FigureItem? figureItem;

  @override
  State<_AutoMoveFlyingCards> createState() => _AutoMoveFlyingCardsState();
}

class _AutoMoveFlyingCardsState extends State<_AutoMoveFlyingCards>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final List<Animation<Offset>> _positionAnimations;

  static const _duration = Duration(milliseconds: 250);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: _duration,
      vsync: this,
    );

    final count = widget.cards.length.clamp(
      0,
      widget.sourcePositions.length.clamp(0, widget.targetPositions.length),
    );

    _positionAnimations = List.generate(count, (int i) {
      return Tween<Offset>(
        begin: widget.sourcePositions[i],
        end: widget.targetPositions[i],
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
    });

    _controller.forward();
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              for (var i = 0; i < _positionAnimations.length; i++)
                Positioned(
                  left: _positionAnimations[i].value.dx,
                  top: _positionAnimations[i].value.dy,
                  child: CardWidget(
                    card: widget.cards[i],
                    cardWidth: widget.cardWidth,
                    figureItem: widget.figureItem,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _IntroCardBack extends StatefulWidget {
  const _IntroCardBack({
    required this.screenCenter,
    required this.targetPosition,
    required this.cardWidth,
    required this.cardBackOption,
    required this.onComplete,
  });

  final Offset screenCenter;
  final Offset targetPosition;
  final double cardWidth;
  final CardBackItem cardBackOption;
  final VoidCallback onComplete;

  @override
  State<_IntroCardBack> createState() => _IntroCardBackState();
}

class _IntroCardBackState extends State<_IntroCardBack>
    with TickerProviderStateMixin {
  // Phase 1: present (fade-in + subtle scale)
  late final AnimationController _presentController;
  late final Animation<double> _fadeAnimation;
  late final Animation<double> _presentScaleAnimation;

  // Phase 2: fly to stock pile
  late final AnimationController _flyController;
  late final Animation<Offset> _flyPositionAnimation;
  late final Animation<double> _flyScaleAnimation;

  static const _presentDuration = Duration(milliseconds: 400);
  static const _flyDuration = Duration(milliseconds: 500);
  static const double _bigScale = 5;

  @override
  void initState() {
    super.initState();

    // Phase 1: fade-in 0→1, scale 0.8→1.0 (at big size)
    _presentController = AnimationController(
      duration: _presentDuration,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _presentController, curve: Curves.easeOut),
    );
    _presentScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _presentController, curve: Curves.easeOut),
    );

    // Phase 2: fly from center to stock pile, scale _bigScale→1.0
    _flyController = AnimationController(
      duration: _flyDuration,
      vsync: this,
    );

    final double bigWidth = widget.cardWidth * _bigScale;
    final double bigHeight = CardDimensions.cardHeight(bigWidth);

    // Centered position at big size
    final Offset centeredPos = Offset(
      widget.screenCenter.dx - bigWidth / 2,
      widget.screenCenter.dy - bigHeight / 2,
    );

    _flyPositionAnimation = Tween<Offset>(
      begin: centeredPos,
      end: widget.targetPosition,
    ).animate(
      CurvedAnimation(parent: _flyController, curve: Curves.easeInOutCubic),
    );

    _flyScaleAnimation = Tween<double>(begin: _bigScale, end: 1.0).animate(
      CurvedAnimation(parent: _flyController, curve: Curves.easeInOutCubic),
    );

    // Chain: present → fly → onComplete
    _presentController.forward();
    _presentController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        _flyController.forward();
      }
    });
    _flyController.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed && mounted) {
        widget.onComplete();
      }
    });
  }

  @override
  void dispose() {
    _presentController.dispose();
    _flyController.dispose();
    super.dispose();
  }

  Widget _buildCardBack(double width) {
    final double height = CardDimensions.cardHeight(width);
    final CardBackItem option = widget.cardBackOption;

    if (option.isImage) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
          border: Border.all(color: Colors.white24, width: 1),
          boxShadow: const [
            BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6)),
          ],
        ),
        child: ClipRRect(
          borderRadius:
              BorderRadius.circular(CardDimensions.borderRadius - 1),
          child: Image.asset(option.assetPath!, fit: BoxFit.fill),
        ),
      );
    }

    final Color backColor = option.color ?? const Color(0xFF1565C0);
    final Color patternColor = option.colorPattern ?? const Color(0xFF1976D2);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
        border: Border.all(color: patternColor, width: 1),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Center(
        child: Container(
          width: width * 0.7,
          height: height * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
            border: Border.all(color: patternColor, width: 1),
          ),
          child: Center(
            child: Text(
              '\u2660',
              style: TextStyle(color: patternColor, fontSize: width * 0.4),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: Listenable.merge([_presentController, _flyController]),
        builder: (BuildContext context, Widget? child) {
          final bool isFlying = _presentController.isCompleted;

          if (isFlying) {
            // Phase 2: fly from center to stock pile
            final double currentScale = _flyScaleAnimation.value;
            final double currentWidth = widget.cardWidth * currentScale;
            return Stack(
              children: [
                Positioned(
                  left: _flyPositionAnimation.value.dx,
                  top: _flyPositionAnimation.value.dy,
                  child: _buildCardBack(currentWidth),
                ),
              ],
            );
          }

          // Phase 1: present at big size in center
          final double presentScale = _presentScaleAnimation.value;
          final double bigWidth = widget.cardWidth * _bigScale * presentScale;
          final double bigHeight = CardDimensions.cardHeight(bigWidth);
          return Stack(
            children: [
              Positioned(
                left: widget.screenCenter.dx - bigWidth / 2,
                top: widget.screenCenter.dy - bigHeight / 2,
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: _buildCardBack(bigWidth),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _UndoButton extends StatelessWidget {
  const _UndoButton({
    required this.canUndo,
    required this.onPressed,
  });

  final bool canUndo;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canUndo ? onPressed : null,
      child: AnimatedOpacity(
        opacity: canUndo ? 1.0 : 0.35,
        duration: const Duration(milliseconds: 200),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF3A4A3E), Color(0xFF2A3530)],
            ),
            border: Border.all(color: const Color(0xFF4A5A4E)),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2)),
            ],
          ),
          child: const Icon(Icons.undo, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}
