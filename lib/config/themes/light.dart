import 'package:flutter/material.dart';

ThemeData getLightTheme(ColorScheme colorScheme) => ThemeData().copyWith(
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
