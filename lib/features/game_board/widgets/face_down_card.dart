import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/card_dimensions.dart';

class FaceDownCard extends StatelessWidget {
  const FaceDownCard({
    super.key,
    required this.cardWidth,
  });

  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: AppTheme.cardBack,
        borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
        border: Border.all(color: AppTheme.cardBackPattern, width: 1),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 2,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: cardWidth * 0.7,
          height: cardHeight * 0.7,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
            border: Border.all(color: AppTheme.cardBackPattern, width: 1),
          ),
          child: Center(
            child: Text(
              '♠',
              style: TextStyle(
                color: AppTheme.cardBackPattern,
                fontSize: cardWidth * 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
