import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../core/theme/app_theme.dart';

class StockPileWidget extends StatelessWidget {
  const StockPileWidget({
    super.key,
    required this.dealsRemaining,
    required this.cardWidth,
    required this.onTap,
  });

  final int dealsRemaining;
  final double cardWidth;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);

    if (dealsRemaining == 0) {
      return SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.emptyPile,
            borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
            border: Border.all(color: Colors.white24),
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth + (dealsRemaining - 1) * 3.0,
        height: cardHeight,
        child: Stack(
          children: [
            for (var i = 0; i < dealsRemaining && i < 5; i++)
              Positioned(
                left: i * 3.0,
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  decoration: BoxDecoration(
                    color: AppTheme.cardBack,
                    borderRadius:
                        BorderRadius.circular(CardDimensions.borderRadius),
                    border:
                        Border.all(color: AppTheme.cardBackPattern, width: 1),
                  ),
                  child: i == dealsRemaining - 1 || i == 4
                      ? Center(
                          child: Text(
                            '$dealsRemaining',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: cardWidth * 0.35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
