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
    final fontSize = cardWidth * 0.28;

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
            Text(
              card.rank.symbol,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                height: 1.0,
              ),
            ),
            Text(
              card.suit.symbol,
              style: TextStyle(
                color: color,
                fontSize: fontSize * 0.8,
                height: 1.0,
              ),
            ),
            const Spacer(),
            Align(
              alignment: Alignment.center,
              child: Text(
                card.suit.symbol,
                style: TextStyle(
                  color: color,
                  fontSize: fontSize * 1.8,
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
