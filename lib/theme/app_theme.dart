import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

/// Worldnity Design System — Theme
/// Style benchmark: Apple / Linear / Vercel — flat, no gradients, no heavy shadows.
class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bg,
    primaryColor: AppColors.brand,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.brand,
      primary: AppColors.brand,
      background: AppColors.bg,
      error: AppColors.error,
      brightness: Brightness.light,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: AppColors.textPrimary),
      titleTextStyle: AppTextStyles.h3,
    ),

    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.bgMuted, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.brand,
        foregroundColor: Colors.white,
        textStyle: AppTextStyles.button,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 0,
      ),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.brand,
      unselectedItemColor: AppColors.textFaint,
      selectedLabelStyle: AppTextStyles.label.copyWith(color: AppColors.brand),
      unselectedLabelStyle: AppTextStyles.label,
      type: BottomNavigationBarType.fixed,
      elevation: 4,
    ),

    dividerColor: AppColors.bgMuted,

    textTheme: TextTheme(
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,
      titleMedium: AppTextStyles.h4,
      bodyMedium: AppTextStyles.body,
      labelLarge: AppTextStyles.button,
    ),
  );
}
