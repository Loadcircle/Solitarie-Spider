import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── Primary palette ──
  static const Color feltGreen = Color(0xFF1E5E2A);
  static const Color secondaryBackground = Color(0xFF174D22);
  static const Color surface = Color(0xFF1F2E22);

  // ── Buttons ──
  static const Color primaryButton = Color(0xFF2F7D3A);
  static const Color primaryButtonPressed = Color(0xFF276A32);

  // ── Text ──
  static const Color primaryText = Color(0xFFEAF3EC);
  static Color secondaryText = const Color(0xFFEAF3EC).withValues(alpha: 0.7);
  static Color disabledText = const Color(0xFFEAF3EC).withValues(alpha: 0.4);

  // ── HUD ──
  static Color hudBackground = Colors.black.withValues(alpha: 0.15);

  // ── Gradient ──
  static const LinearGradient tableGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [feltGreen, secondaryBackground],
  );

  // ── Card colors (unchanged) ──
  static const Color cardWhite = Color(0xFFFAFAFA);
  static const Color cardBack = Color(0xFF1565C0);
  static const Color cardBackPattern = Color(0xFF1976D2);
  static const Color redSuit = Color(0xFFC62828);
  static const Color blackSuit = Color(0xFF0A1A3A);
  static const Color emptyPile = Color(0xFF0D3B0E);
  static const Color goldAccent = Color(0xFFFFD54F);

  static ThemeData get theme {
    final TextTheme baseText = GoogleFonts.interTextTheme(
      ThemeData(brightness: Brightness.dark).textTheme,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: feltGreen,
        brightness: Brightness.dark,
      ),
      textTheme: baseText.copyWith(
        titleLarge: baseText.titleLarge?.copyWith(fontWeight: FontWeight.w600),
        titleMedium: baseText.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        labelLarge: baseText.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        bodyMedium: baseText.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
      ),
      scaffoldBackgroundColor: feltGreen,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0A1A0E),
        foregroundColor: primaryText,
        elevation: 0,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50),
          foregroundColor: primaryText,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(0, 48),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          minimumSize: const Size(0, 48),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF2A4A2E)),
        ),
        elevation: 8,
        titleTextStyle: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: primaryText,
        ),
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: primaryText,
        ),
      ),
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      listTileTheme: const ListTileThemeData(
        textColor: primaryText,
      ),
    );
  }
}
