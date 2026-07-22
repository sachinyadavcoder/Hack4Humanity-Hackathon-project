import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryContainer = Color(0xFFE3DFFF); // primary-fixed
  static const Color secondary = Color(0xFFFF6FAE);
  static const Color secondaryContainer = Color(0xFFFFD9E4); // secondary-fixed
  static const Color success = Color(0xFF27AE60);
  static const Color error = Color(0xFFBA1A1A);
  
  static const Color background = Color(0xFFF8F9FA); // Based on user request
  static const Color surface = Colors.white;
  static const Color surfaceDim = Color(0xFFDCD8E5);
  
  static const Color onBackground = Color(0xFF1B1B24);
  static const Color onSurface = Color(0xFF1B1B24);
  static const Color onSurfaceVariant = Color(0xFF464555);
  static const Color outline = Color(0xFF777587);

  // Border Radius
  static const double borderRadius = 20.0;
  
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primary,
      primaryContainer: primaryContainer,
      secondary: secondary,
      secondaryContainer: secondaryContainer,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: onSurface,
      onError: Colors.white,
      outline: outline,
    ),
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.beVietnamProTextTheme().copyWith(
      headlineLarge: GoogleFonts.beVietnamPro(fontSize: 30, fontWeight: FontWeight.w700, color: onSurface, letterSpacing: -0.5),
      headlineMedium: GoogleFonts.beVietnamPro(fontSize: 24, fontWeight: FontWeight.w600, color: onSurface),
      headlineSmall: GoogleFonts.beVietnamPro(fontSize: 20, fontWeight: FontWeight.w600, color: onSurface),
      titleLarge: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w600, color: onSurface),
      bodyLarge: GoogleFonts.beVietnamPro(fontSize: 18, fontWeight: FontWeight.w400, color: onSurface, height: 1.5),
      bodyMedium: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w400, color: onSurface, height: 1.5),
      labelLarge: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w600, color: onSurface, letterSpacing: 0.5),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(double.infinity, 48), // Large touch targets
        shape: const StadiumBorder(), // Pill shaped
        textStyle: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      elevation: 0,
      centerTitle: true,
      iconTheme: const IconThemeData(color: onSurface),
      titleTextStyle: GoogleFonts.beVietnamPro(fontSize: 20, fontWeight: FontWeight.w600, color: onSurface),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: outline, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: outline.withOpacity(0.5), width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: primary, width: 2),
      ),
    ),
  );
}
