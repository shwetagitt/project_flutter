import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryBlue = Color(0xFF1E40AF);      // Deep Blue
  static const Color lightBlue = Color(0xFF3B82F6);        // Bright Blue
  static const Color accentTeal = Color(0xFF0891B2);       // Teal
  static const Color successGreen = Color(0xFF059669);     // Emerald
  static const Color warningAmber = Color(0xFFD97706);     // Amber
  static const Color errorRed = Color(0xFFDC2626);         // Red
  static const Color purpleAccent = Color(0xFF7C3AED);     // Purple
  static const Color pinkAccent = Color(0xFFDB2777);       // Pink

  // Admin Colors
  static const Color adminOrange = Color(0xFFEA580C);      // Orange
  static const Color adminDeepOrange = Color(0xFFC2410C);  // Deep Orange

  // Background Colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color cardBackground = Colors.white;
  static const Color surfaceColor = Color(0xFFF8FAFC);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.blue,
    primaryColor: primaryBlue,
    useMaterial3: true,

    colorScheme: ColorScheme.light(
      brightness: Brightness.light,
      primary: primaryBlue,
      onPrimary: Colors.white,
      secondary: accentTeal,
      onSecondary: Colors.white,
      tertiary: successGreen,
      surface: cardBackground,
      onSurface: Color(0xFF1F2937),
      surfaceContainer: surfaceColor,
      error: errorRed,
      onError: Colors.white,
      outline: Color(0xFFE5E7EB),
      shadow: Colors.black.withOpacity(0.1),
    ),

    scaffoldBackgroundColor: lightBackground,

    appBarTheme: AppBarTheme(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
      elevation: 0,
      shadowColor: Colors.transparent,
      centerTitle: false,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: Colors.white),
      actionsIconTheme: IconThemeData(color: Colors.white),
      surfaceTintColor: Colors.transparent,
    ),

    cardTheme: CardThemeData(
      color: cardBackground,
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      surfaceTintColor: Colors.transparent,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: primaryBlue.withOpacity(0.3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        side: BorderSide(color: primaryBlue, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: cardBackground,
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Color(0xFFE5E7EB), width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: primaryBlue, width: 2.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorRed, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: errorRed, width: 2.5),
      ),
      labelStyle: TextStyle(color: Color(0xFF6B7280), fontWeight: FontWeight.w500),
      hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
    ),

    listTileTheme: ListTileThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: accentTeal,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: CircleBorder(),
    ),

    iconTheme: IconThemeData(
      color: Color(0xFF6B7280),
      size: 24,
    ),

    dividerTheme: DividerThemeData(
      color: Color(0xFFE5E7EB),
      thickness: 1,
      space: 1,
    ),
  );

  static final ThemeData darkTheme = lightTheme;
}
