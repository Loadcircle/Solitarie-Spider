import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../game/move_validator.dart';
import '../../../models/playing_card.dart';
import '../../../models/shop_item.dart';
import 'card_widget.dart';
import 'face_down_card.dart';
import 'empty_pile.dart';

class TableauColumn extends StatefulWidget {
  const TableauColumn({
    super.key,
    required this.columnIndex,
    required this.cards,
    required this.cardWidth,
    this.highlightMovable = false,
    this.onCardDragStarted,
    this.onDragUpdate,
    this.onDragEnd,
    this.onAcceptDrop,
    this.onCardTap,
    this.shakeTarget,
    this.hideLastCard = false,
    this.hideFromIndex,
    this.cardBackOption,
    this.figureItem,
  });

  final int columnIndex;
  final List<PlayingCard> cards;
  final double cardWidth;
  final bool highlightMovable;
  final void Function(int columnIndex, int cardIndex)? onCardDragStarted;
  final void Function(DragUpdateDetails details)? onDragUpdate;
  final void Function()? onDragEnd;
  final void Function(int fromColumn, int fromCardIndex)? onAcceptDrop;
  final void Function(int columnIndex, int cardIndex)? onCardTap;
  final ({int col, int card})? shakeTarget;
  final bool hideLastCard;
  final int? hideFromIndex;
  final CardBackItem? cardBackOption;
  final FigureItem? figureItem;

  @override
  State<TableauColumn> createState() => _TableauColumnState();
}

class _TableauColumnState extends State<TableauColumn> {
  int? _draggingFromIndex;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(widget.cardWidth);
    final faceUpOverlap = CardDimensions.faceUpOverlap(cardHeight);
    final faceDownOverlap = CardDimensions.faceDownOverlap(cardHeight);

    if (widget.cards.isEmpty) {
      return DragTarget<Map<String, int>>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (details) {
          final data = details.data;
          widget.onAcceptDrop
              ?.call(data['fromColumn']!, data['fromCardIndex']!);
        },
        builder: (context, candidateData, rejectedData) {
          return EmptyPile(cardWidth: widget.cardWidth);
        },
      );
    }

    // Calculate total height needed
    double totalHeight = 0;
    for (var i = 0; i < widget.cards.length; i++) {
      if (i == widget.cards.length - 1) {
        totalHeight += cardHeight;
      } else {
        totalHeight +=
            widget.cards[i].isFaceUp ? faceUpOverlap : faceDownOverlap;
      }
    }

    return DragTarget<Map<String, int>>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        final data = details.data;
        widget.onAcceptDrop
            ?.call(data['fromColumn']!, data['fromCardIndex']!);
      },
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: widget.cardWidth,
          height: totalHeight,
          child: Stack(
            children: [
              for (var i = 0; i < widget.cards.length; i++)
                Positioned(
                  top:
                      _getCardTop(i, faceUpOverlap, faceDownOverlap),
                  child: (widget.hideLastCard &&
                              i == widget.cards.length - 1) ||
                          (widget.hideFromIndex != null &&
                              i >= widget.hideFromIndex!)
                      ? Opacity(opacity: 0, child: _buildCard(i))
                      : _buildCard(i),
                ),
            ],
          ),
        );
      },
    );
  }

  double _getCardTop(
      int index, double faceUpOverlap, double faceDownOverlap) {
    double top = 0;
    for (var i = 0; i < index; i++) {
      top += widget.cards[i].isFaceUp ? faceUpOverlap : faceDownOverlap;
    }
    return top;
  }

  bool _canPickUpFrom(int index) {
    return MoveValidator.canPickUp(widget.cards.sublist(index));
  }

  Widget _buildCard(int index) {
    final card = widget.cards[index];

    if (!card.isFaceUp) {
      return FaceDownCard(
        cardWidth: widget.cardWidth,
        cardBackOption: widget.cardBackOption,
      );
    }

    final bool canPickUp = _canPickUpFrom(index);

    // Check if this card should be dimmed due to drag
    final bool isDragDimmed = _draggingFromIndex != null &&
        index >= _draggingFromIndex!;

    // Check if this card should be dimmed as non-draggable
    final bool isBlockedDimmed =
        widget.highlightMovable && !canPickUp;

    // Check if this card is the shake target
    final bool isShakeTarget = widget.shakeTarget != null &&
        widget.shakeTarget!.col == widget.columnIndex &&
        widget.shakeTarget!.card == index;

    Widget cardWidget = CardWidget(card: card, cardWidth: widget.cardWidth, figureItem: widget.figureItem);

    // Apply dimming
    if (isDragDimmed) {
      cardWidget = Opacity(opacity: 0.3, child: cardWidget);
    } else if (isBlockedDimmed) {
      cardWidget = ColorFiltered(
        colorFilter: const ColorFilter.mode(
          Colors.black45,
          BlendMode.srcATop,
        ),
        child: cardWidget,
      );
    }

    // Wrap in shake animation if needed
    if (isShakeTarget) {
      cardWidget = _ShakeWidget(child: cardWidget);
    }

    // If blocked (non-draggable) and highlight is on, just return with tap for shake
    if (widget.highlightMovable && !canPickUp) {
      if (widget.onCardTap != null) {
        return GestureDetector(
          onTap: () =>
              widget.onCardTap?.call(widget.columnIndex, index),
          child: cardWidget,
        );
      }
      return cardWidget;
    }

    // Draggable card
    return Draggable<Map<String, int>>(
      data: {'fromColumn': widget.columnIndex, 'fromCardIndex': index},
      onDragStarted: () {
        setState(() => _draggingFromIndex = index);
        widget.onCardDragStarted?.call(widget.columnIndex, index);
      },
      onDragUpdate: (details) => widget.onDragUpdate?.call(details),
      onDragEnd: (_) {
        setState(() => _draggingFromIndex = null);
        widget.onDragEnd?.call();
      },
      onDraggableCanceled: (_, _) {
        setState(() => _draggingFromIndex = null);
      },
      feedback: Material(
        color: Colors.transparent,
        child: _buildDragFeedback(index),
      ),
      childWhenDragging: const SizedBox.shrink(),
      child: widget.onCardTap != null
          ? GestureDetector(
              onTap: () =>
                  widget.onCardTap?.call(widget.columnIndex, index),
              child: cardWidget,
            )
          : cardWidget,
    );
  }

  Widget _buildDragFeedback(int startIndex) {
    final cardHeight = CardDimensions.cardHeight(widget.cardWidth);
    final faceUpOverlap = CardDimensions.faceUpOverlap(cardHeight);
    final draggedCards = widget.cards.sublist(startIndex);

    final totalHeight =
        cardHeight + (draggedCards.length - 1) * faceUpOverlap;

    return SizedBox(
      width: widget.cardWidth,
      height: totalHeight,
      child: Stack(
        children: [
          for (var i = 0; i < draggedCards.length; i++)
            Positioned(
              top: i * faceUpOverlap,
              child: CardWidget(
                  card: draggedCards[i], cardWidth: widget.cardWidth, figureItem: widget.figureItem),
            ),
        ],
      ),
    );
  }
}

class _ShakeWidget extends StatefulWidget {
  const _ShakeWidget({required this.child});

  final Widget child;

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _offsetAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: 5), weight: 1),
      TweenSequenceItem(tween: Tween(begin: 5, end: -5), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -5, end: 3), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 3, end: -3), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -3, end: 0), weight: 1),
    ]).animate(_controller);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _offsetAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_offsetAnimation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

