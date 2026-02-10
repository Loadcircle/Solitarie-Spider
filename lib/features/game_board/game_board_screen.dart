import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/card_dimensions.dart';
import '../../core/enums/difficulty.dart';
import '../../l10n/generated/app_localizations.dart';
import '../../models/game_result.dart';
import '../../models/game_state.dart';
import '../../providers/game_provider.dart';
import '../../providers/timer_provider.dart';
import '../../providers/history_provider.dart';
import '../../routes/app_router.dart';
import 'widgets/tableau_area.dart';
import 'widgets/stock_pile_widget.dart';
import 'widgets/completed_area.dart';
import 'widgets/game_hud.dart';
import 'widgets/win_dialog.dart';

class GameBoardScreen extends ConsumerStatefulWidget {
  const GameBoardScreen({super.key, this.difficulty});

  final Difficulty? difficulty;

  @override
  ConsumerState<GameBoardScreen> createState() => _GameBoardScreenState();
}

class _GameBoardScreenState extends ConsumerState<GameBoardScreen> {
  bool _hasShownWinDialog = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initGame();
    });
  }

  void _initGame() {
    final gameState = ref.read(gameProvider);
    if (widget.difficulty != null || gameState == null) {
      final difficulty = widget.difficulty ?? Difficulty.oneSuit;
      ref.read(gameProvider.notifier).startNewGame(difficulty);
      ref.read(timerProvider.notifier).start();
      _hasShownWinDialog = false;
    } else {
      ref.read(timerProvider.notifier).resume();
    }
  }

  void _onAcceptDrop(int toColumn, int fromColumn, int fromCardIndex) {
    ref.read(gameProvider.notifier).moveCards(
          fromColumn: fromColumn,
          cardIndex: fromCardIndex,
          toColumn: toColumn,
        );
  }

  void _onDealFromStock() {
    final l10n = AppLocalizations.of(context)!;
    final state = ref.read(gameProvider);
    if (state == null) return;

    if (state.stock.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.stockEmpty)),
      );
      return;
    }

    // Check all columns have at least one card
    final hasEmptyColumn = state.tableau.any((col) => col.isEmpty);
    if (hasEmptyColumn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.allColumnsMustHaveCards)),
      );
      return;
    }

    ref.read(gameProvider.notifier).dealFromStock();
  }

  void _showWinDialog() {
    final state = ref.read(gameProvider);
    if (state == null) return;

    ref.read(timerProvider.notifier).stop();

    // Record game result
    ref.read(historyProvider.notifier).addResult(GameResult(
          dateTime: DateTime.now(),
          difficulty: state.difficulty,
          score: state.score,
          time: state.elapsed,
          moves: state.moveCount,
          isWon: true,
        ));

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => WinDialog(
        score: state.score,
        moves: state.moveCount,
        elapsed: state.elapsed,
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

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameProvider);
    final elapsed = ref.watch(timerProvider);

    if (gameState == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Check for win
    if (gameState.isWon && !_hasShownWinDialog) {
      _hasShownWinDialog = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showWinDialog();
      });
    }

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) {
          ref.read(timerProvider.notifier).stop();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              GameHud(
                score: gameState.score,
                moves: gameState.moveCount,
                elapsed: elapsed,
                completedSequences: gameState.completedSequences,
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: TableauArea(
                    tableau: gameState.tableau,
                    onAcceptDrop: _onAcceptDrop,
                  ),
                ),
              ),
              _buildBottomBar(gameState),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(GameState gameState) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = CardDimensions.cardWidth(constraints.maxWidth);

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          color: Colors.black26,
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.home, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              const Spacer(),
              CompletedArea(
                completedSequences: gameState.completedSequences,
                cardWidth: cardWidth,
              ),
              const Spacer(),
              StockPileWidget(
                dealsRemaining: gameState.stockDealsRemaining,
                cardWidth: cardWidth,
                onTap: _onDealFromStock,
              ),
            ],
          ),
        );
      },
    );
  }
}
