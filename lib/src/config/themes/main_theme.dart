// theme.dart
import 'package:flutter/material.dart';

ThemeData buildThemeData() {
  final theme = ThemeData();

  return ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.lightBlue,
      primary: Colors.yellow,
      onPrimary: Colors.black,
    ),
    useMaterial3: true,
    fontFamily: 'Lato',
    appBarTheme: const AppBarTheme(
      titleTextStyle: TextStyle(
        fontSize: 24,
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
        color: theme.colorScheme.secondary,
      ),
      prefixIconColor: theme.colorScheme.secondary,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 28,
      ),
      titleMedium: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      titleSmall: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  );
}
