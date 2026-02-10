import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/card_dimensions.dart';

class EmptyPile extends StatelessWidget {
  const EmptyPile({
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
        color: AppTheme.emptyPile,
        borderRadius: BorderRadius.circular(CardDimensions.borderRadius),
        border: Border.all(
          color: Colors.white24,
          width: 1,
        ),
      ),
    );
  }
}
