import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Backgrounds
  static const Color bgPrimary = Color(0xFF090A0B);
  static const Color bgSecondary = Color(0xFF111214);
  static const Color surface = Color(0xFF181A1D);
  static const Color surfaceElevated = Color(0xFF202226);
  static const Color cardBg = Color(0xFF1C1E22);

  // Accents (Gold & Yellow Luxury)
  static const Color goldAccent = Color(0xFFF5D547);
  static const Color goldLight = Color(0xFFFFE36A);
  static const Color goldMuted = Color(0xFFD4B33A);
  static const Color goldDark = Color(0xFF9A7B1C);
  static const Color goldBorder = Color(0x66F5D547);
  static const Color goldGlow = Color(0x33F5D547);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFA7A9AE);
  static const Color textMuted = Color(0xFF6F7278);
  static const Color textGold = Color(0xFFE8C858);

  // Utility
  static const Color border = Color(0xFF292C30);
  static const Color success = Color(0xFF6EDC8A);
  static const Color danger = Color(0xFFFF6B6B);
}

class AppTypography {
  static TextStyle serifTitle({
    double fontSize = 38,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textGold,
    double letterSpacing = -0.5,
    double height = 1.1,
  }) {
    return GoogleFonts.cormorantGaramond(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  static TextStyle sansHeading({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w600,
    Color color = AppColors.textPrimary,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: -0.2,
    );
  }

  static TextStyle sansBody({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = AppColors.textSecondary,
    double height = 1.4,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle sansLabel({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Color color = AppColors.textMuted,
  }) {
    return GoogleFonts.plusJakartaSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: 0.5,
    );
  }
}
