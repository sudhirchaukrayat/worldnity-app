import 'package:flutter/material.dart';

/// Worldnity Design System — Color Tokens
/// Source: global.css (web) — kept identical for brand consistency
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color bg = Color(0xFFF7F7F7);
  static const Color bgSubtle = Color(0xFFF4F4F4);
  static const Color bgMuted = Color(0xFFEDEDED);

  // Text
  static const Color textPrimary = Color(0xFF0D0D0D);
  static const Color textMuted = Color(0xFF3C3C3C);
  static const Color textFaint = Color(0xFF6B6B6B);

  // Brand
  static const Color brand = Color(0xFF6013DC);
  static const Color brandHover = Color(0xFF4D0FB8);

  // Status (used heavily for Scam Risk Levels)
  static const Color success = Color(0xFF1E8E3E); // Low risk
  static const Color warning = Color(0xFFE8780C); // Medium risk
  static const Color error = Color(0xFFD93025);   // High / Critical risk
  static const Color info = Color(0xFF1A73E8);

  // Primary (CTAs, footer)
  static const Color primary = Color(0xFF000000);

  // Risk level helper
  static Color riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'low':
        return success;
      case 'medium':
        return warning;
      case 'high':
      case 'critical':
        return error;
      default:
        return textFaint;
    }
  }
}
