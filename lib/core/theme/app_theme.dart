import 'package:flutter/material.dart';

ThemeData appTheme() {
  return ThemeData(
    fontFamily: 'Inter',
    scaffoldBackgroundColor: AppColors.background,
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,

    cardTheme: CardThemeData(
      color: AppColors.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      )
    )
  );
}

class AppColors {
  static const background = Color(0xFFF6F9FC);
  static const card = Colors.white;

  static const primary = Color(0xff2b6dff);
  static const secondary = Color(0xFF6EDC8C);
  static const accent = Color(0xFFFFC83D);

  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);

  static const buttonGradientColor = Color(0xff2b6dff);
  static const deadlineDanger = Color(0xFFFF6B6B);
}

class AppText {
  static const title = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary
  );
  static const subtitle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: AppColors.textSecondary
  );
  static const cardTtle = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500
  );
  static const mediumtitle = TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary
  );
  static const buttonsWhiteText = TextStyle(
    fontSize: 18,
    color: AppColors.background,
  );
}