import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Brand Colors (from Stitch AI design)
  static const Color primary = Color(0xFF4D41DF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF675DF9);
  static const Color onPrimaryContainer = Color(0xFFFFFBFF);
  static const Color primaryFixed = Color(0xFFE3DFFF);
  static const Color primaryFixedDim = Color(0xFFC4C0FF);
  static const Color inversePrimary = Color(0xFFC4C0FF);

  static const Color secondary = Color(0xFFAA2A6A);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFE6EAD);
  static const Color onSecondaryContainer = Color(0xFF700040);
  static const Color secondaryFixed = Color(0xFFFFD9E4);
  static const Color secondaryFixedDim = Color(0xFFFFB0CC);

  static const Color tertiary = Color(0xFF006A35);
  static const Color onTertiary = Color(0xFFFFFFFF);
  static const Color tertiaryContainer = Color(0xFF008645);
  static const Color onTertiaryContainer = Color(0xFFF6FFF4);

  static const Color error = Color(0xFFBA1A1A);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color errorContainer = Color(0xFFFFDAD6);
  static const Color onErrorContainer = Color(0xFF93000A);

  static const Color background = Color(0xFFF8F9FA);
  static const Color onBackground = Color(0xFF191C1D);
  static const Color surface = Color(0xFFF8F9FA);
  static const Color onSurface = Color(0xFF191C1D);
  static const Color surfaceVariant = Color(0xFFE1E3E4);
  static const Color onSurfaceVariant = Color(0xFF464555);
  static const Color surfaceTint = Color(0xFF4F44E2);

  static const Color outline = Color(0xFF777587);
  static const Color outlineVariant = Color(0xFFC7C4D8);

  static const Color surfaceContainerLowest = Color(0xFFFFFFFF);
  static const Color surfaceContainerLow = Color(0xFFF3F4F5);
  static const Color surfaceContainer = Color(0xFFEDEEEF);
  static const Color surfaceContainerHigh = Color(0xFFE7E8E9);
  static const Color surfaceContainerHighest = Color(0xFFE1E3E4);
  static const Color surfaceBright = Color(0xFFF8F9FA);
  static const Color surfaceDim = Color(0xFFD9DADB);

  static const Color inverseSurface = Color(0xFF2E3132);
  static const Color inverseOnSurface = Color(0xFFF0F1F2);

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primary,
        onPrimary: onPrimary,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: secondary,
        onSecondary: onSecondary,
        secondaryContainer: secondaryContainer,
        onSecondaryContainer: onSecondaryContainer,
        tertiary: tertiary,
        onTertiary: onTertiary,
        tertiaryContainer: tertiaryContainer,
        onTertiaryContainer: onTertiaryContainer,
        error: error,
        onError: onError,
        errorContainer: errorContainer,
        onErrorContainer: onErrorContainer,
        surface: surface,
        onSurface: onSurface,
        surfaceContainerHighest: surfaceContainerHighest,
        onSurfaceVariant: onSurfaceVariant,
        outline: outline,
        outlineVariant: outlineVariant,
        inverseSurface: inverseSurface,
        onInverseSurface: inverseOnSurface,
        inversePrimary: inversePrimary,
        surfaceTint: surfaceTint,
      ),
    );

    final textTheme = GoogleFonts.beVietnamProTextTheme(base.textTheme);

    return base.copyWith(
      textTheme: textTheme,
      scaffoldBackgroundColor: background,
      appBarTheme: AppBarTheme(
        backgroundColor: surface,
        foregroundColor: onSurface,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.beVietnamPro(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceContainerLowest,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: outlineVariant, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          side: const BorderSide(color: outline),
          textStyle: GoogleFonts.beVietnamPro(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerLowest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: outlineVariant),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        labelStyle: GoogleFonts.beVietnamPro(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: onSurfaceVariant,
        ),
        hintStyle: GoogleFonts.beVietnamPro(
          fontSize: 16,
          color: outline,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceContainerLowest,
        indicatorColor: primaryFixed,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.beVietnamPro(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: primary,
            );
          }
          return GoogleFonts.beVietnamPro(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: onSurfaceVariant,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: primary, size: 24);
          }
          return const IconThemeData(color: onSurfaceVariant, size: 24);
        }),
        elevation: 3,
        shadowColor: Colors.black12,
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        labelStyle: GoogleFonts.beVietnamPro(fontSize: 12, fontWeight: FontWeight.w500),
      ),
      dividerTheme: const DividerThemeData(
        color: outlineVariant,
        thickness: 0.5,
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: GoogleFonts.beVietnamPro(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: onSurface,
        ),
        subtitleTextStyle: GoogleFonts.beVietnamPro(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: onSurfaceVariant,
        ),
      ),
    );
  }
}
