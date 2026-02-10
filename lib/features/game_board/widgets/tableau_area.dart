import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../models/playing_card.dart';
import 'tableau_column.dart';

class TableauArea extends StatelessWidget {
  const TableauArea({
    super.key,
    required this.tableau,
    this.onCardDragStarted,
    this.onDragUpdate,
    this.onDragEnd,
    this.onAcceptDrop,
  });

  final List<List<PlayingCard>> tableau;
  final void Function(int columnIndex, int cardIndex)? onCardDragStarted;
  final void Function(DragUpdateDetails details)? onDragUpdate;
  final void Function()? onDragEnd;
  final void Function(int toColumn, int fromColumn, int fromCardIndex)?
      onAcceptDrop;

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
                    columnIndex: i,
                    cards: tableau[i],
                    cardWidth: cardWidth,
                    onCardDragStarted: onCardDragStarted,
                    onDragUpdate: onDragUpdate,
                    onDragEnd: onDragEnd,
                    onAcceptDrop: (fromColumn, fromCardIndex) {
                      onAcceptDrop?.call(i, fromColumn, fromCardIndex);
                    },
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
