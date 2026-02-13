class CardDimensions {
  CardDimensions._();

  static const double cardAspectRatio = 2.5 / 4.0; // width / height
  static const double faceUpOverlapFraction = 0.40;
  static const double faceDownOverlapFraction = 0.20;
  static const double columnSpacing = 2.0;
  static const double tableauPadding = 4.0;
  static const double borderRadius = 4.0;

  static double cardWidth(double availableWidth) {
    final totalSpacing =
        (9 * columnSpacing) + (2 * tableauPadding);
    return (availableWidth - totalSpacing) / 10;
  }

  static double cardHeight(double cardWidth) {
    return cardWidth / cardAspectRatio;
  }

  static double faceUpOverlap(double cardHeight) {
    return cardHeight * faceUpOverlapFraction;
  }

  static double faceDownOverlap(double cardHeight) {
    return cardHeight * faceDownOverlapFraction;
  }
}
