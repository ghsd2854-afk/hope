import 'package:flutter/material.dart';
import 'package:hobe/core/theme/colors.dart';

class AppThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.primaryEnd,
    scaffoldBackgroundColor: AppColors.lightBackground,
    cardColor: AppColors.lightCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: AppColors.textLightPrimary,
      centerTitle: true,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textLightPrimary),
      titleLarge: TextStyle(
        color: AppColors.textLightPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryEnd,
      secondary: AppColors.primaryStart,
      surface: AppColors.lightCard,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.primaryEnd,
    scaffoldBackgroundColor: AppColors.darkBackground,
    cardColor: AppColors.darkCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textDarkPrimary),
      titleLarge: TextStyle(
        color: AppColors.textDarkPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryEnd,
      secondary: AppColors.primaryStart,
      surface: AppColors.darkCard,
    ),
  );
}
