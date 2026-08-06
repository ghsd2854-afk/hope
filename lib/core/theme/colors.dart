import 'package:flutter/material.dart';

class AppColors {
  // الألوان الأساسية (البنفسجي)
  static const Color primaryStart = Color(0xFFC9B8EC); // بنفسجي فاتح
  static const Color primaryEnd = Color.fromARGB(
    255,
    148,
    114,
    217,
  ); // اللون البنفسجي الرئيسي
  static const Color Selection = Color(0xFF4A148C);
  static const Color backgroundColor = Color.fromARGB(255, 218, 203, 248);
  // static const Color degreecolor = Color.fromARGB(255, 148, 114, 217);

  // DARK THEME
  static const Color darkBackground = Color(
    0xFF0D0C11,
  ); // خلفية داكنة جداً وأنيقة
  static const Color darkCard = Color(0xFF1B1A21); // كرت داكن متباين

  // LIGHT THEME
  static const Color lightBackground = Color(
    0xFFF9F9FC,
  ); // رمادي فاتح جداً (خلفية)
  static const Color lightCard = Colors.white; // كرت أبيض نقي

  // TEXT
  static const Color textDarkPrimary = Colors.white;
  static const Color textLightPrimary = Color(0xFF2D2D2D); // رمادي داكن للنصوص
  static const Color textSecondary = Color(0xFF8E8E93); // رمادي للنصوص الفرعية

  // BORDERS
  static const Color border = Color(0xFFE5E5EA);
}

extension GradientExtension on AppColors {
  static const LinearGradient purpleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.primaryStart, // اللون الفاتح
      AppColors.primaryEnd, // اللون الغامق
    ],
  );
}
