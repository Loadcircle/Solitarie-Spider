import 'package:flutter/material.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../core/theme/app_theme.dart';

class CompletedArea extends StatelessWidget {
  const CompletedArea({
    super.key,
    required this.completedSequences,
    required this.cardWidth,
    this.slotKeys,
  });

  final int completedSequences;
  final double cardWidth;
  final List<GlobalKey>? slotKeys;

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < 8; i++)
            Container(
              key: slotKeys != null ? slotKeys![i] : null,
              width: cardWidth,
              height: cardHeight,
              decoration: BoxDecoration(
                color: i < completedSequences
                    ? AppTheme.cardWhite
                    : AppTheme.emptyPile,
                borderRadius:
                    BorderRadius.circular(CardDimensions.borderRadius),
                border: Border.all(
                  color: i < completedSequences
                      ? AppTheme.goldAccent
                      : Colors.white24,
                  width: i < completedSequences ? 1.5 : 1.0,
                ),
              ),
              child: i < completedSequences
                  ? Center(
                      child: Text(
                        '\u2660',
                        style: TextStyle(
                          fontSize: cardWidth * 0.3,
                          color: AppTheme.blackSuit,
                        ),
                      ),
                    )
                  : null,
            ),
        ],
      ),
    );
  }
}
