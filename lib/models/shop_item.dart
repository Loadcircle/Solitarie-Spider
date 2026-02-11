import 'package:flutter/material.dart';

enum BackgroundOption { defaultGreen, darkEmerald, image1, image2 }

enum CardBackOption { defaultBlue, darkRed, image1, image2 }

extension BackgroundOptionExt on BackgroundOption {
  String get displayNameKey {
    switch (this) {
      case BackgroundOption.defaultGreen:
        return 'bgDefaultGreen';
      case BackgroundOption.darkEmerald:
        return 'bgDarkEmerald';
      case BackgroundOption.image1:
        return 'bgImage1';
      case BackgroundOption.image2:
        return 'bgImage2';
    }
  }

  bool get isImage =>
      this == BackgroundOption.image1 || this == BackgroundOption.image2;

  bool get isGradient => gradient != null && !isImage;

  LinearGradient? get gradient {
    switch (this) {
      case BackgroundOption.defaultGreen:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1E5E2A), Color(0xFF174D22)],
        );
      case BackgroundOption.darkEmerald:
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF0A2F1A), Color(0xFF071F10)],
        );
      default:
        return null;
    }
  }

  String? get assetPath {
    switch (this) {
      case BackgroundOption.image1:
        return 'assets/images/backgrounds/background_n1.png';
      case BackgroundOption.image2:
        return 'assets/images/backgrounds/background_n2.png';
      default:
        return null;
    }
  }

  Color? get color {
    switch (this) {
      case BackgroundOption.defaultGreen:
        return const Color(0xFF1E5E2A);
      case BackgroundOption.darkEmerald:
        return const Color(0xFF0A2F1A);
      default:
        return null;
    }
  }

  Color? get colorLight {
    switch (this) {
      case BackgroundOption.defaultGreen:
        return const Color(0xFF2E7D32);
      case BackgroundOption.darkEmerald:
        return const Color(0xFF0F4025);
      default:
        return null;
    }
  }
}

extension CardBackOptionExt on CardBackOption {
  String get displayNameKey {
    switch (this) {
      case CardBackOption.defaultBlue:
        return 'cbDefaultBlue';
      case CardBackOption.darkRed:
        return 'cbDarkRed';
      case CardBackOption.image1:
        return 'cbImage1';
      case CardBackOption.image2:
        return 'cbImage2';
    }
  }

  bool get isImage =>
      this == CardBackOption.image1 || this == CardBackOption.image2;

  String? get assetPath {
    switch (this) {
      case CardBackOption.image1:
        return 'assets/images/cards/card_1.png';
      case CardBackOption.image2:
        return 'assets/images/cards/card_2.png';
      default:
        return null;
    }
  }

  Color? get color {
    switch (this) {
      case CardBackOption.defaultBlue:
        return const Color(0xFF1565C0);
      case CardBackOption.darkRed:
        return const Color(0xFF8B0000);
      default:
        return null;
    }
  }

  Color? get colorPattern {
    switch (this) {
      case CardBackOption.defaultBlue:
        return const Color(0xFF1976D2);
      case CardBackOption.darkRed:
        return const Color(0xFFA52A2A);
      default:
        return null;
    }
  }
}
