import 'package:flutter/material.dart';

ThemeData buildLightTheme() {
  const primary = Color(0xFF2F2F2F);
  const onPrimary = Color(0xFFFFFFFF);
  const primaryContainer = Color(0xFFCCE5E3);
  const onPrimaryContainer = Color(0xFF00201E);

  const secondary = Color(0xFFFEE1B6);
  const onSecondary = Color(0xFF281800);

  const surface = Color(0xFFFFFFFF);
  const surfaceVariant = Color(0xFFF7F9F8);
  const outline = Color(0xFF707978);

  const success = Color(0xFF4CAF50);
  const error = Color(0xFFB00020);

  final colorScheme = const ColorScheme.light(
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    onSecondary: onSecondary,
    surface: surface,
    surfaceVariant: surfaceVariant,
    outline: outline,
    error: error,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: surfaceVariant,

    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        letterSpacing: -0.3,
      ),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ).apply(bodyColor: primary, displayColor: primary, fontFamily: 'Inter'),

    appBarTheme: const AppBarTheme(
      backgroundColor: surfaceVariant,
      foregroundColor: primary,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 1,
      shadowColor: Colors.black.withOpacity(0.04),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primary,
        side: const BorderSide(color: outline),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: primaryContainer,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    tabBarTheme: const TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: outline,
      indicatorSize: TabBarIndicatorSize.label,
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: outline,
      type: BottomNavigationBarType.fixed,
    ),

    extensions: [StatusColors(success: success)],
  );
}

ThemeData buildDarkTheme() {
  const primary = Color(0xFFE2E2E2);
  const onPrimary = Color(0xFF2F2F2F);

  const primaryContainer = Color(0xFF2F2F2F);
  const onPrimaryContainer = Color(0xFFE2E2E2);

  const secondary = Color(0xFF80D1C8);
  const tertiary = Color(0xFFEFBD8E);

  const background = Color(0xFF1A1C1E);
  const surface = Color(0xFF222427);
  const outline = Color(0xFF8A9291);

  const success = Color(0xFF81C784);

  final colorScheme = const ColorScheme.dark(
    primary: primary,
    onPrimary: onPrimary,
    primaryContainer: primaryContainer,
    onPrimaryContainer: onPrimaryContainer,
    secondary: secondary,
    tertiary: tertiary,
    background: background,
    surface: surface,
    onSurface: primary,
    outline: outline,
  );

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: colorScheme,
    scaffoldBackgroundColor: background,

    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ).apply(bodyColor: primary, displayColor: primary, fontFamily: 'Inter'),

    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      foregroundColor: primary,
      elevation: 0,
      centerTitle: true,
    ),

    cardTheme: CardThemeData(
      color: surface,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: outline),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: primaryContainer,
      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surface,
      selectedItemColor: primary,
      unselectedItemColor: outline,
    ),

    extensions: [StatusColors(success: success)],
  );
}

@immutable
class StatusColors extends ThemeExtension<StatusColors> {
  final Color success;

  const StatusColors({required this.success});

  @override
  StatusColors copyWith({Color? success}) {
    return StatusColors(success: success ?? this.success);
  }

  @override
  StatusColors lerp(ThemeExtension<StatusColors>? other, double t) {
    if (other is! StatusColors) return this;
    return StatusColors(success: Color.lerp(success, other.success, t)!);
  }
}
