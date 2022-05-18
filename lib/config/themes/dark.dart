import 'package:flutter/material.dart';

ThemeData getDarkTheme(ColorScheme colorScheme) => ThemeData.dark().copyWith(
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
