import 'package:flutter/material.dart';
import 'package:hobe/core/theme/colors.dart';


class AppThemes {
  static final light = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,

    cardColor: AppColors.lightCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.black,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textLightPrimary),
    ),

    colorScheme: ColorScheme.light(
      primary: AppColors.primaryStart,
      secondary: AppColors.primaryEnd,
    ),
  );

  static final dark = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,

    cardColor: AppColors.darkCard,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: Colors.white,
    ),

    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: AppColors.textDarkPrimary),
    ),

    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryStart,
      secondary: AppColors.primaryEnd,
    ),
  );
}