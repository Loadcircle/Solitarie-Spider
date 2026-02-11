import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../models/playing_card.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.card,
    required this.cardWidth,
  });

  final PlayingCard card;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);
    final isRed = card.suit.isRed;
    final color = isRed ? AppTheme.redSuit : AppTheme.blackSuit;
    final rankFontSize = cardWidth * 0.45;
    final suitFontSize = cardWidth * 0.35;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppTheme.cardWhite,
        borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
        border: Border.all(color: Colors.grey.shade400, width: 0.5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(cardWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      card.rank.symbol,
                      style: TextStyle(
                        color: color,
                        fontSize: rankFontSize,
                        fontWeight: FontWeight.bold,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                Text(
                  card.suit.symbol,
                  style: TextStyle(
                    color: color,
                    fontSize: suitFontSize,
                    height: 1.0,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                card.suit.symbol,
                style: TextStyle(
                  color: color,
                  fontSize: rankFontSize * 1.8,
                  height: 1.0,
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
