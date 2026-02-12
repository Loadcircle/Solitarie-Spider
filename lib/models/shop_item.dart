import 'package:flutter/material.dart';

class BackgroundItem {
  final String id;
  final String displayNameKey;
  final int? unlockLevel;
  final String? assetPath;
  final LinearGradient? gradient;
  final Color? color;
  final Color? colorLight;

  const BackgroundItem({
    required this.id,
    required this.displayNameKey,
    this.unlockLevel,
    this.assetPath,
    this.gradient,
    this.color,
    this.colorLight,
  });

  bool get isImage => assetPath != null;
  bool get isGradient => gradient != null && !isImage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BackgroundItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class FigureItem {
  final String id;
  final String displayNameKey;
  final int? unlockLevel;
  final String folderPath;

  const FigureItem({
    required this.id,
    required this.displayNameKey,
    this.unlockLevel,
    required this.folderPath,
  });

  bool get isImage => true;
  String get previewPath => '$folderPath/preview.png';
  String get jackPath => '$folderPath/jack.png';
  String get queenPath => '$folderPath/queen.png';
  String get kingPath => '$folderPath/king.png';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FigureItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class CardBackItem {
  final String id;
  final String displayNameKey;
  final int? unlockLevel;
  final String? assetPath;
  final Color? color;
  final Color? colorPattern;

  const CardBackItem({
    required this.id,
    required this.displayNameKey,
    this.unlockLevel,
    this.assetPath,
    this.color,
    this.colorPattern,
  });

  bool get isImage => assetPath != null;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardBackItem && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
