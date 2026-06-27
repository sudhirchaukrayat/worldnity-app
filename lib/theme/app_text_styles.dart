import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Worldnity Design System — Typography Tokens
/// Font: Plus Jakarta Sans (locked, do not change)
class AppTextStyles {
  AppTextStyles._();

  static TextStyle _base(double size, FontWeight weight, {Color? color}) {
    return GoogleFonts.plusJakartaSans(
      fontSize: size,
      fontWeight: weight,
      color: color ?? AppColors.textPrimary,
    );
  }

  // Headings — h1/h2 extrabold(800), h3 bold(700), h4-h6 semibold(600)
  static TextStyle h1 = _base(28, FontWeight.w800);
  static TextStyle h2 = _base(24, FontWeight.w800);
  static TextStyle h3 = _base(20, FontWeight.w700);
  static TextStyle h4 = _base(17, FontWeight.w600);

  // Body — 400
  static TextStyle body = _base(15, FontWeight.w400);
  static TextStyle bodyMuted = _base(15, FontWeight.w400, color: AppColors.textMuted);

  // Card title — semibold(600)
  static TextStyle cardTitle = _base(16, FontWeight.w600);

  // Button — semibold(600)
  static TextStyle button = _base(15, FontWeight.w600, color: Colors.white);

  // Label (uppercase, small — tags like "Risk Level")
  static TextStyle label = GoogleFonts.plusJakartaSans(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
    color: AppColors.textFaint,
  );
}
