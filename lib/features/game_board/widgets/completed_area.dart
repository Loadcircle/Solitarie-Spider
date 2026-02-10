import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../core/theme/app_theme.dart';

class CompletedArea extends StatelessWidget {
  const CompletedArea({
    super.key,
    required this.completedSequences,
    required this.cardWidth,
  });

  final int completedSequences;
  final double cardWidth;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);

    if (completedSequences == 0) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      height: cardHeight,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < completedSequences; i++)
            Padding(
              padding: EdgeInsets.only(left: i > 0 ? 2.0 : 0),
              child: Container(
                width: cardWidth * 0.6,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: AppTheme.cardWhite,
                  borderRadius:
                      BorderRadius.circular(CardDimensions.borderRadius),
                  border: Border.all(color: AppTheme.goldAccent, width: 1.5),
                ),
                child: Center(
                  child: Text(
                    '♠',
                    style: TextStyle(
                      fontSize: cardWidth * 0.3,
                      color: AppTheme.blackSuit,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
