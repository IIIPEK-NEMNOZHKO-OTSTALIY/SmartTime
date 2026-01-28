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
  static const green = Color(0xFF0FC163);
  static const peach = Color(0xFFF69077);
  static const cheery = Color(0xFFC10063);
  static const indigo = Color(0xFF5A38E8);
  static const purple = Color(0xFFB02DE6);
  static const yellow = Color(0xFFFFC83D);
  static const transp = Colors.white;

  static const colors = [
    primary, cheery, green, yellow, peach, indigo, purple, transp
  ];

  static const textPrimary = Color(0xFF1F2937);
  static const textSecondary = Color(0xFF6B7280);
  static const lightGray = Color(0xFFBEC8D5);

  static const buttonGradientColor = Color(0xff2b6dff);
  static const deadlineDanger = Color(0xFFFF6B6B);
}

class AppText {
  static const title = TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary
  );
  static const hugeTitle = TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w700,
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
  static const progressText = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.primary
  );

}