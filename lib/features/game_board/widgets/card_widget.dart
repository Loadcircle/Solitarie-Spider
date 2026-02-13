import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/enums/rank.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/card_dimensions.dart';
import '../../../models/playing_card.dart';
import '../../../models/shop_item.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({
    super.key,
    required this.card,
    required this.cardWidth,
    this.figureItem,
  });

  final PlayingCard card;
  final double cardWidth;
  final FigureItem? figureItem;

  String? _figurePath() {
    if (figureItem == null) return null;
    switch (card.rank) {
      case Rank.jack:
        return figureItem!.jackPath;
      case Rank.queen:
        return figureItem!.queenPath;
      case Rank.king:
        return figureItem!.kingPath;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardHeight = CardDimensions.cardHeight(cardWidth);
    final isRed = card.suit.isRed;
    final color = isRed ? AppTheme.redSuit : AppTheme.blackSuit;
    final rankFontSize = cardWidth * 0.55;
    final suitFontSize = cardWidth * 0.35;
    final String? figPath = _figurePath();

    return Container(
      width: cardWidth,
      height: cardHeight,
      clipBehavior: Clip.hardEdge,
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
        padding: EdgeInsets.only(left: cardWidth * 0.04, top: cardWidth * 0.03),
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
                      style: GoogleFonts.libreBaskerville(
                        color: color,
                        fontSize: rankFontSize,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ),
                ),
                ColorFiltered(
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  child: Text(
                    card.suit.symbol,
                    style: TextStyle(
                      fontSize: suitFontSize,
                      height: 1.0,
                    ),
                  ),
                ),
              ],
            ),
            if (figPath != null) ...[
              Expanded(
                child: ClipRect(
                  child: Align(
                    alignment: const Alignment(0, 0.5),
                    child: OverflowBox(
                      maxWidth: cardWidth * 0.9,
                      maxHeight: cardHeight * 0.85,
                      child: Image.asset(
                        figPath,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ] else ...[
              const Spacer(),
              Align(
                alignment: Alignment.center,
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                  child: Text(
                    card.suit.symbol,
                    style: TextStyle(
                      fontSize: rankFontSize * 1.5,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ],
        ),
      ),
    );
  }
}
