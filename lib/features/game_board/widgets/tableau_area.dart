import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../models/playing_card.dart';
import '../../../models/shop_item.dart';
import 'tableau_column.dart';

class TableauArea extends StatelessWidget {
  const TableauArea({
    super.key,
    required this.tableau,
    this.highlightMovable = false,
    this.onCardDragStarted,
    this.onDragUpdate,
    this.onDragEnd,
    this.onAcceptDrop,
    this.onCardTap,
    this.shakeTarget,
    this.hideLastCard = false,
    this.columnKeys,
    this.hideCardsInColumn,
    this.hideCardsFromIndex,
    this.cardBackOption,
  });

  final List<List<PlayingCard>> tableau;
  final bool highlightMovable;
  final void Function(int columnIndex, int cardIndex)? onCardDragStarted;
  final void Function(DragUpdateDetails details)? onDragUpdate;
  final void Function()? onDragEnd;
  final void Function(int toColumn, int fromColumn, int fromCardIndex)?
      onAcceptDrop;
  final void Function(int columnIndex, int cardIndex)? onCardTap;
  final ({int col, int card})? shakeTarget;
  final bool hideLastCard;
  final List<GlobalKey>? columnKeys;
  final int? hideCardsInColumn;
  final int? hideCardsFromIndex;
  final CardBackOption? cardBackOption;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = CardDimensions.cardWidth(constraints.maxWidth);

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: CardDimensions.tableauPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < tableau.length; i++) ...[
                if (i > 0)
                  const SizedBox(width: CardDimensions.columnSpacing),
                Expanded(
                  child: TableauColumn(
                    key: columnKeys?[i],
                    columnIndex: i,
                    cards: tableau[i],
                    cardWidth: cardWidth,
                    highlightMovable: highlightMovable,
                    onCardDragStarted: onCardDragStarted,
                    onDragUpdate: onDragUpdate,
                    onDragEnd: onDragEnd,
                    onAcceptDrop: (fromColumn, fromCardIndex) {
                      onAcceptDrop?.call(i, fromColumn, fromCardIndex);
                    },
                    onCardTap: onCardTap,
                    shakeTarget: shakeTarget,
                    hideLastCard: hideLastCard,
                    hideFromIndex: hideCardsInColumn == i
                        ? hideCardsFromIndex
                        : null,
                    cardBackOption: cardBackOption,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
