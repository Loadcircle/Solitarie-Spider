import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../core/theme/app_theme.dart';
import '../../../models/shop_item.dart';

class StockPileWidget extends StatelessWidget {
  const StockPileWidget({
    super.key,
    required this.dealsRemaining,
    required this.cardWidth,
    required this.onTap,
    this.cardBackOption,
  });

  final int dealsRemaining;
  final double cardWidth;
  final VoidCallback onTap;
  final CardBackOption? cardBackOption;

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

    final option = cardBackOption ?? CardBackOption.defaultBlue;
    final Color backColor = option.color ?? AppTheme.cardBack;
    final Color patternColor = option.colorPattern ?? AppTheme.cardBackPattern;
    final bool isImageBack = option.isImage;

    final offset = cardWidth * 0.5;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth + (dealsRemaining - 1) * offset,
        height: cardHeight,
        child: Stack(
          children: [
            for (var i = 0; i < dealsRemaining && i < 5; i++)
              Positioned(
                left: i * offset,
                child: isImageBack
                    ? Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              CardDimensions.borderRadius),
                          border: Border.all(color: Colors.white24, width: 1),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                              CardDimensions.borderRadius - 1),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(option.assetPath!,
                                  fit: BoxFit.fill),
                              if (i == dealsRemaining - 1 || i == 4)
                                Center(
                                  child: Text(
                                    '$dealsRemaining',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: cardWidth * 0.35,
                                      fontWeight: FontWeight.bold,
                                      shadows: const [
                                        Shadow(
                                          blurRadius: 4,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : Container(
                        width: cardWidth,
                        height: cardHeight,
                        decoration: BoxDecoration(
                          color: backColor,
                          borderRadius: BorderRadius.circular(
                              CardDimensions.borderRadius),
                          border: Border.all(color: patternColor, width: 1),
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
