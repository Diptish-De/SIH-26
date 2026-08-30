import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color primary = Color(0xFF0891B2); // Cyan / Teal
  static const Color primaryDark = Color(0xFF0E7490);
  static const Color primaryLight = Color(0xFFE0F7FA);
  static const Color tealHeader = Color(0xFF0E7490);
  
  static const Color bg = Color(0xFFF0F9FF); // Sky 50 background
  static const Color desktopBg = Color(0xFF0F172A); // Dark slate surrounding background
  static const Color surface = Colors.white;
  static const Color text = Color(0xFF0F172A);
  static const Color textSub = Color(0xFF334155);
  static const Color muted = Color(0xFF64748B);
  static const Color border = Color(0xFFE2E8F0);

  static const Color success = Color(0xFF16A34A);
  static const Color successBg = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFC2410C);
  static const Color warningBg = Color(0xFFFFF7ED);
  static const Color amber = Color(0xFFA16207);
  static const Color amberBg = Color(0xFFFEFCE8);
  static const Color danger = Color(0xFFDC2626);
  static const Color purple = Color(0xFF9333EA);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          textStyle: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.bold),
        ),
      ),
      textTheme: GoogleFonts.notoSansTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.text),
        displayMedium: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.text),
        titleLarge: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text),
        titleMedium: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.text),
        bodyLarge: GoogleFonts.notoSans(fontSize: 15, color: AppColors.text),
        bodyMedium: GoogleFonts.notoSans(fontSize: 13, color: AppColors.textSub),
        bodySmall: GoogleFonts.notoSans(fontSize: 11, color: AppColors.muted),
      ),
    );
  }
}
