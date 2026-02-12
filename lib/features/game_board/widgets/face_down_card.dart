import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../core/constants/shop_registry.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/shop_item.dart';

class FaceDownCard extends StatelessWidget {
  const FaceDownCard({
    super.key,
    required this.cardWidth,
    this.cardBackOption,
  });

  final double cardWidth;
  final CardBackItem? cardBackOption;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);
    final option = cardBackOption ?? ShopRegistry.defaultCardBack;

    if (option.isImage) {
      return Container(
        width: cardWidth,
        height: cardHeight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
          border: Border.all(color: Colors.white24, width: 1),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 2,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(CardDimensions.borderRadius - 1),
          child: Image.asset(option.assetPath!, fit: BoxFit.fill),
        ),
      );
    }

    final Color backColor = option.color ?? AppTheme.cardBack;
    final Color patternColor = option.colorPattern ?? AppTheme.cardBackPattern;

    return Container(
      width: cardWidth,
      height: cardHeight,
      decoration: BoxDecoration(
        color: backColor,
        borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
        border: Border.all(color: patternColor, width: 1),
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
            border: Border.all(color: patternColor, width: 1),
          ),
          child: Center(
            child: Text(
              '\u2660',
              style: TextStyle(
                color: patternColor,
                fontSize: cardWidth * 0.4,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
