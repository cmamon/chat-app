import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'kora_design_system.dart';

class KoraTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: KoraColors.background,
      colorScheme: const ColorScheme.dark(
        primary: KoraColors.primary,
        secondary: KoraColors.primaryLight,
        surface: KoraColors.surface,
        error: KoraColors.error,
      ),
      textTheme: GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme)
          .copyWith(
            displayLarge: GoogleFonts.outfit(
              color: KoraColors.textPrimary,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
            bodyLarge: GoogleFonts.outfit(color: KoraColors.textPrimary),
            bodyMedium: GoogleFonts.outfit(color: KoraColors.textSecondary),
          ),
    );
  }
}
