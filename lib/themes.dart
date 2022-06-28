import 'package:flutter/material.dart';

class Themes {
  final ThemeData light;
  final ThemeData dark;

  Themes(ColorScheme scheme)
      : light = _getLightTheme(scheme),
        dark = _getDarkTheme(scheme);

  static ThemeData _getDarkTheme(ColorScheme colorScheme) =>
      ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.grey,
          brightness: Brightness.dark,
        ),
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
        toggleableActiveColor: colorScheme.primary,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        dividerTheme: const DividerThemeData(space: 0),
      );

  static ThemeData _getLightTheme(ColorScheme colorScheme) =>
      ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
        cardTheme: const CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
        toggleableActiveColor: colorScheme.primary,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
        ),
        dividerTheme: const DividerThemeData(space: 0),
      );
}
