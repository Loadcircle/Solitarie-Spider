import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color feltGreen = Color(0xFF1B5E20);
  static const Color feltGreenLight = Color(0xFF2E7D32);
  static const Color cardWhite = Color(0xFFFAFAFA);
  static const Color cardBack = Color(0xFF1565C0);
  static const Color cardBackPattern = Color(0xFF1976D2);
  static const Color redSuit = Color(0xFFC62828);
  static const Color blackSuit = Color(0xFF212121);
  static const Color emptyPile = Color(0xFF0D3B0E);
  static const Color goldAccent = Color(0xFFFFD54F);

  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: feltGreen,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: feltGreen,
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF0D3B0E),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: feltGreenLight,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: const CardThemeData(
        color: cardWhite,
        elevation: 2,
      ),
    );
  }
}
