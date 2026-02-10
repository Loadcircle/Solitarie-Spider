import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../models/playing_card.dart';
import 'card_widget.dart';
import 'face_down_card.dart';
import 'empty_pile.dart';

class TableauColumn extends StatelessWidget {
  const TableauColumn({
    super.key,
    required this.columnIndex,
    required this.cards,
    required this.cardWidth,
    this.onCardDragStarted,
    this.onDragUpdate,
    this.onDragEnd,
    this.onAcceptDrop,
  });

  final int columnIndex;
  final List<PlayingCard> cards;
  final double cardWidth;
  final void Function(int columnIndex, int cardIndex)? onCardDragStarted;
  final void Function(DragUpdateDetails details)? onDragUpdate;
  final void Function()? onDragEnd;
  final void Function(int fromColumn, int fromCardIndex)? onAcceptDrop;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);
    final faceUpOverlap = CardDimensions.faceUpOverlap(cardHeight);
    final faceDownOverlap = CardDimensions.faceDownOverlap(cardHeight);

    if (cards.isEmpty) {
      return DragTarget<Map<String, int>>(
        onWillAcceptWithDetails: (_) => true,
        onAcceptWithDetails: (details) {
          final data = details.data;
          onAcceptDrop?.call(data['fromColumn']!, data['fromCardIndex']!);
        },
        builder: (context, candidateData, rejectedData) {
          return EmptyPile(cardWidth: cardWidth);
        },
      );
    }

    // Calculate total height needed
    double totalHeight = 0;
    for (var i = 0; i < cards.length; i++) {
      if (i == cards.length - 1) {
        totalHeight += cardHeight;
      } else {
        totalHeight += cards[i].isFaceUp ? faceUpOverlap : faceDownOverlap;
      }
    }

    return DragTarget<Map<String, int>>(
      onWillAcceptWithDetails: (_) => true,
      onAcceptWithDetails: (details) {
        final data = details.data;
        onAcceptDrop?.call(data['fromColumn']!, data['fromCardIndex']!);
      },
      builder: (context, candidateData, rejectedData) {
        return SizedBox(
          width: cardWidth,
          height: totalHeight,
          child: Stack(
            children: [
              for (var i = 0; i < cards.length; i++)
                Positioned(
                  top: _getCardTop(i, faceUpOverlap, faceDownOverlap),
                  child: _buildCard(i),
                ),
            ],
          ),
        );
      },
    );
  }

  double _getCardTop(int index, double faceUpOverlap, double faceDownOverlap) {
    double top = 0;
    for (var i = 0; i < index; i++) {
      top += cards[i].isFaceUp ? faceUpOverlap : faceDownOverlap;
    }
    return top;
  }

  Widget _buildCard(int index) {
    final card = cards[index];

    if (!card.isFaceUp) {
      return FaceDownCard(cardWidth: cardWidth);
    }

    return Draggable<Map<String, int>>(
      data: {'fromColumn': columnIndex, 'fromCardIndex': index},
      onDragStarted: () => onCardDragStarted?.call(columnIndex, index),
      onDragUpdate: (details) => onDragUpdate?.call(details),
      onDragEnd: (_) => onDragEnd?.call(),
      feedback: Material(
        color: Colors.transparent,
        child: _buildDragFeedback(index),
      ),
      childWhenDragging: Opacity(
        opacity: 0.3,
        child: CardWidget(card: card, cardWidth: cardWidth),
      ),
      child: CardWidget(card: card, cardWidth: cardWidth),
    );
  }

  Widget _buildDragFeedback(int startIndex) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);
    final faceUpOverlap = CardDimensions.faceUpOverlap(cardHeight);
    final draggedCards = cards.sublist(startIndex);

    final totalHeight = cardHeight + (draggedCards.length - 1) * faceUpOverlap;

    return SizedBox(
      width: cardWidth,
      height: totalHeight,
      child: Stack(
        children: [
          for (var i = 0; i < draggedCards.length; i++)
            Positioned(
              top: i * faceUpOverlap,
              child: CardWidget(card: draggedCards[i], cardWidth: cardWidth),
            ),
        ],
      ),
    );
  }
}
