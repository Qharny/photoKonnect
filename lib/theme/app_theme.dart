import 'package:flutter/material.dart';

import 'app_color.dart';


class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.offWhite,
    primaryColor: AppColors.primaryBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: AppColors.darkText),
      bodyMedium: TextStyle(color: AppColors.darkText),
      bodyLarge: TextStyle(color: AppColors.mediumGray),
    ),
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentPurple,
      error: AppColors.errorRed,
      surface: AppColors.offWhite,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    primaryColor: AppColors.primaryBlue,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodyLarge: TextStyle(color: Colors.grey),
    ),
    colorScheme: ColorScheme.dark(
      primary: AppColors.primaryBlue,
      secondary: AppColors.accentPurple,
      error: AppColors.errorRed,
      surface: Colors.black,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.white,
      ),
    ),
  );
}
