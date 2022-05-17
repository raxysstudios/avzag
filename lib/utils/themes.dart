import 'package:flutter/material.dart';

class ThemeSet {
  final ThemeData light;
  final ThemeData dark;

  ThemeSet(this.light, this.dark);
}

ThemeSet getThemes(BuildContext context) {
  final colorScheme = Theme.of(context).colorScheme;
  final floatingActionButtonTheme = FloatingActionButtonThemeData(
    backgroundColor: colorScheme.primary,
    foregroundColor: colorScheme.onPrimary,
  );
  const cardTheme = CardTheme(
    clipBehavior: Clip.antiAlias,
  );
  const dividerTheme = DividerThemeData(space: 0);

  final lightTheme = ThemeData().copyWith(
    scaffoldBackgroundColor: Colors.blueGrey.shade50,
    colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.grey,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
    ),
    cardTheme: cardTheme,
    toggleableActiveColor: colorScheme.primary,
    floatingActionButtonTheme: floatingActionButtonTheme,
    dividerTheme: dividerTheme,
  );
  final darkTheme = ThemeData.dark().copyWith(
    colorScheme: ColorScheme.fromSwatch(
      accentColor: Colors.grey,
      brightness: Brightness.dark,
    ),
    cardTheme: cardTheme,
    toggleableActiveColor: colorScheme.primary,
    floatingActionButtonTheme: floatingActionButtonTheme,
    dividerTheme: dividerTheme,
  );
  return ThemeSet(lightTheme, darkTheme);
}
