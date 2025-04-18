import 'package:flutter/material.dart';

import '../constant_colors.dart';

class MdTextTheme {
  static const TextTheme lightTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32,  fontFamily: AppThemeData.extraBold),
    displayMedium: TextStyle(fontSize: 28, fontFamily: AppThemeData.bold),
    displaySmall: TextStyle(fontSize: 24,  fontFamily: AppThemeData.semiBold),

    headlineLarge: TextStyle(fontSize: 22, fontFamily: AppThemeData.semiBold),
    headlineMedium: TextStyle(fontSize: 20,  fontFamily: AppThemeData.medium),
    headlineSmall: TextStyle(fontSize: 18,  fontFamily: AppThemeData.medium),

    titleLarge: TextStyle(fontSize: 16,  fontFamily: AppThemeData.semiBold),
    titleMedium: TextStyle(fontSize: 14,  fontFamily: AppThemeData.medium),
    titleSmall: TextStyle(fontSize: 13,  fontFamily: AppThemeData.medium),


    bodyLarge: TextStyle(fontSize: 16,  fontFamily: AppThemeData.regular),
    bodyMedium: TextStyle(fontSize: 14,  fontFamily: AppThemeData.regular),
    bodySmall: TextStyle(fontSize: 12, fontFamily: AppThemeData.regular),

    labelLarge: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: AppThemeData.bold),
    labelMedium: TextStyle(fontSize: 14, color: Colors.grey, fontFamily: AppThemeData.semiBold),
    labelSmall: TextStyle(fontSize: 12,color: Colors.grey, fontFamily: AppThemeData.medium),
  );

  static const TextTheme darkTextTheme = TextTheme(
    displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: AppThemeData.extraBold),
    displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: AppThemeData.bold),
    displaySmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: AppThemeData.semiBold),

    headlineLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: AppThemeData.semiBold),
    headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white, fontFamily: AppThemeData.medium),
    headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white, fontFamily: AppThemeData.medium),

    titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, fontFamily: AppThemeData.semiBold),
    titleMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white70, fontFamily: AppThemeData.medium),
    titleSmall: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white60, fontFamily: AppThemeData.medium),

    bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.white, fontFamily: AppThemeData.regular),
    bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal, color: Colors.white70, fontFamily: AppThemeData.regular),
    bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal, color: Colors.white54, fontFamily: AppThemeData.regular),

    labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white, fontFamily: AppThemeData.semiBold),
    labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, color: Colors.white70, fontFamily: AppThemeData.medium),
    labelSmall: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, color: Colors.white60, fontFamily: AppThemeData.medium),
  );
}