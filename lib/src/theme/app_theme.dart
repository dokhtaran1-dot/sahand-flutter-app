import 'package:flutter/material.dart';

class AppColors {
  static const background = Color(0xFF0E1218);
  static const surface = Color(0xFF141A21);
  static const surfaceVariant = Color(0xFF1F2630);
  static const accent = Color(0xFFB58E4F);
  static const secondary = Color(0xFF888E9A);
  static const textPrimary = Color(0xFFF8F4EE);
  static const textSecondary = Color(0xFFB5B5B5);
  static const success = Color(0xFF6BB56B);
  static const warning = Color(0xFFD9B56B);
  static const border = Color(0xFF2C343F);
}

class AppSpacing {
  static const double xs = 6;
  static const double sm = 12;
  static const double md = 18;
  static const double lg = 26;
  static const double xl = 36;
  static const double xxl = 48;
}

class AppTextStyles {
  static TextStyle heading({double size = 28}) => TextStyle(
        color: AppColors.textPrimary,
        fontSize: size,
        fontWeight: FontWeight.w700,
        height: 1.3,
      );

  static const TextStyle titleLarge = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.35,
  );

  static const TextStyle titleMedium = TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  static const TextStyle body = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 15,
    height: 1.6,
  );

  static const TextStyle label = TextStyle(
    color: AppColors.secondary,
    fontSize: 13,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.18,
  );
}

class AppTheme {
  static final ColorScheme _darkScheme = const ColorScheme.dark(
    surface: AppColors.surface,
    primary: AppColors.accent,
    onPrimary: AppColors.background,
    secondary: AppColors.secondary,
    onSecondary: AppColors.textPrimary,
    onSurface: AppColors.textPrimary,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    canvasColor: AppColors.background,
    cardColor: AppColors.surface,
    dividerColor: AppColors.border,
    colorScheme: _darkScheme,
    useMaterial3: true,
    iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 20),
    textTheme: const TextTheme(
      bodyMedium: AppTextStyles.body,
      titleMedium: TextStyle(color: AppColors.textPrimary, fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: AppColors.textPrimary, fontSize: 22, fontWeight: FontWeight.w700),
      labelLarge: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: AppColors.background,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.textPrimary,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF6F3EE),
    canvasColor: const Color(0xFFF6F3EE),
    cardColor: Colors.white,
    dividerColor: const Color(0xFFE3DCD2),
    colorScheme: const ColorScheme.light(
      surface: Colors.white,
      primary: AppColors.accent,
      onPrimary: Colors.white,
      secondary: Color(0xFF6C6B67),
      onSecondary: Color(0xFF1C1A17),
      onSurface: Color(0xFF1C1A17),
    ),
    useMaterial3: true,
    iconTheme: const IconThemeData(color: Color(0xFF4B4B4B), size: 20),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Color(0xFF4B4B4B), fontSize: 15, height: 1.6),
      titleMedium: TextStyle(color: Color(0xFF1C1A17), fontSize: 18, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Color(0xFF1C1A17), fontSize: 22, fontWeight: FontWeight.w700),
      labelLarge: TextStyle(color: AppColors.accent, fontWeight: FontWeight.w700),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.accent,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.accent,
        textStyle: const TextStyle(fontWeight: FontWeight.w600),
      ),
    ),
  );
}
