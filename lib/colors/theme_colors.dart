import 'package:flutter/material.dart';

//
class MyColors {
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);

  static const Color primary = Color(0xFF711DB0);
  static const Color secondary = Color(0xFFC21292);
  static const Color accent = Color(0xFFF3EBC6);
  static const Color highlight = Color(0xFFFFA732);
  static const Color background = Color(0xFFEF4040);
}

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: MyColors.whiteColor,
    onPrimary: MyColors.whiteColor,
    secondary: MyColors.primary,
    onSecondary: MyColors.primary,
    error: MyColors.whiteColor,
    onError: MyColors.whiteColor,
    background: MyColors.whiteColor,
    onBackground: MyColors.primary,
    surface: MyColors.primary,
    onSurface: MyColors.whiteColor,
    inverseSurface: MyColors.primary,
    onPrimaryContainer: MyColors.whiteColor,
    onSurfaceVariant: MyColors.whiteColor,
    outline: MyColors.whiteColor,
    primaryContainer: MyColors.secondary,
  ),
  snackBarTheme: const SnackBarThemeData(
      contentTextStyle: TextStyle(
    color: MyColors.whiteColor, // Set your desired text color here
  )),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      color: MyColors.accent, // Set your desired text color here
    ),
    bodyMedium: TextStyle(
      color: MyColors.blackColor, // Set your desired text color here
    ),
    // Add more text styles as needed
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color:
        MyColors.blackColor, // Set the desired color for the refresh indicator
  ),
);

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  iconTheme: const IconThemeData(
    color: MyColors.blackColor,
  ),
  colorScheme: const ColorScheme.dark(
    inverseSurface: MyColors.secondary,
    primaryContainer: MyColors.secondary,
    primary: MyColors.accent,
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(
      color: MyColors.blackColor, // Set the text color to white
    ),
  ),
);
