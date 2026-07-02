import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryContainer,
        onPrimaryContainer: AppColors.onPrimaryContainer,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: AppColors.secondaryContainer,
        onSecondaryContainer: Color(0xFF00391E),
        tertiary: AppColors.tertiary,
        onTertiary: Colors.white,
        tertiaryContainer: AppColors.tertiaryContainer,
        onTertiaryContainer: AppColors.onTertiary,
        error: AppColors.error,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.onSurfaceLight,
        surfaceContainerHighest: AppColors.surfaceVariantLight,
        onSurfaceVariant: AppColors.onSurfaceVariantLight,
        outline: AppColors.outlineLight,
        outlineVariant: Color(0xFFBFC9BE),
        shadow: Color(0x1A000000),
        scrim: Color(0xFF000000),
        inverseSurface: Color(0xFF2E312E),
        onInverseSurface: Color(0xFFF0F1EE),
        inversePrimary: Color(0xFF74C69D),
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: _textTheme(Brightness.light),
      appBarTheme: _appBarTheme(Brightness.light),
      cardTheme: _cardTheme(),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(Brightness.light),
      bottomNavigationBarTheme: _bottomNavTheme(Brightness.light),
      navigationBarTheme: _navigationBarTheme(Brightness.light),
      chipTheme: _chipTheme(Brightness.light),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0E6E0),
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: AppColors.onSurfaceLight,
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.surfaceLight,
        elevation: 8,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: AppColors.surfaceLight,
        elevation: 8,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.primaryContainer,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? Colors.white : AppColors.outlineLight),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? AppColors.primary : AppColors.surfaceVariantLight),
      ),
    );
  }

  static ThemeData get dark {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF74C69D),
        onPrimary: Color(0xFF00391E),
        primaryContainer: Color(0xFF00522D),
        onPrimaryContainer: Color(0xFF96F5BF),
        secondary: Color(0xFF74C69D),
        onSecondary: Color(0xFF003829),
        secondaryContainer: Color(0xFF00513D),
        onSecondaryContainer: Color(0xFF96F5BF),
        tertiary: Color(0xFFFFB47A),
        onTertiary: Color(0xFF3F1E00),
        tertiaryContainer: Color(0xFF5A2D00),
        onTertiaryContainer: Color(0xFFFFDDC1),
        error: Color(0xFFFFB4AB),
        onError: Color(0xFF690005),
        surface: AppColors.surfaceDark,
        onSurface: AppColors.onSurfaceDark,
        surfaceContainerHighest: AppColors.surfaceVariantDark,
        onSurfaceVariant: AppColors.onSurfaceVariantDark,
        outline: AppColors.outlineDark,
        outlineVariant: Color(0xFF3F4A3F),
        shadow: Color(0xFF000000),
        inverseSurface: Color(0xFFE1E4DF),
        onInverseSurface: Color(0xFF2E312E),
        inversePrimary: AppColors.primary,
      ),
    );

    return base.copyWith(
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: _textTheme(Brightness.dark),
      appBarTheme: _appBarTheme(Brightness.dark),
      cardTheme: _cardTheme(isDark: true),
      elevatedButtonTheme: _elevatedButtonTheme(),
      outlinedButtonTheme: _outlinedButtonTheme(),
      textButtonTheme: _textButtonTheme(),
      inputDecorationTheme: _inputDecorationTheme(Brightness.dark),
      bottomNavigationBarTheme: _bottomNavTheme(Brightness.dark),
      navigationBarTheme: _navigationBarTheme(Brightness.dark),
      chipTheme: _chipTheme(Brightness.dark),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF2A3A2A),
        thickness: 1,
        space: 1,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xFF74C69D),
        foregroundColor: const Color(0xFF00391E),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF3A4A3A),
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: AppColors.surfaceDark,
        elevation: 8,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: AppColors.cardDark,
        elevation: 8,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF74C69D),
        linearTrackColor: Color(0xFF00522D),
      ),
    );
  }

  static TextTheme _textTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final textColor = isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight;
    return GoogleFonts.interTextTheme().copyWith(
      displayLarge: GoogleFonts.inter(
          fontSize: 57, fontWeight: FontWeight.w400, letterSpacing: -0.25, color: textColor),
      displayMedium: GoogleFonts.inter(
          fontSize: 45, fontWeight: FontWeight.w400, color: textColor),
      displaySmall: GoogleFonts.inter(
          fontSize: 36, fontWeight: FontWeight.w400, color: textColor),
      headlineLarge: GoogleFonts.inter(
          fontSize: 32, fontWeight: FontWeight.w700, color: textColor),
      headlineMedium: GoogleFonts.inter(
          fontSize: 28, fontWeight: FontWeight.w600, color: textColor),
      headlineSmall: GoogleFonts.inter(
          fontSize: 24, fontWeight: FontWeight.w600, color: textColor),
      titleLarge: GoogleFonts.inter(
          fontSize: 22, fontWeight: FontWeight.w600, color: textColor),
      titleMedium: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.15, color: textColor),
      titleSmall: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: textColor),
      bodyLarge: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5, color: textColor),
      bodyMedium: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25, color: textColor),
      bodySmall: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: textColor),
      labelLarge: GoogleFonts.inter(
          fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1, color: textColor),
      labelMedium: GoogleFonts.inter(
          fontSize: 12, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: textColor),
      labelSmall: GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5, color: textColor),
    );
  }

  static AppBarTheme _appBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return AppBarTheme(
      elevation: 0,
      scrolledUnderElevation: 1,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      foregroundColor: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
      systemOverlayStyle: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
      ),
      iconTheme: IconThemeData(
        color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        size: 24,
      ),
      actionsIconTheme: IconThemeData(
        color: isDark ? AppColors.onSurfaceDark : AppColors.onSurfaceLight,
        size: 24,
      ),
    );
  }

  static CardThemeData _cardTheme({bool isDark = false}) {
    return CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: isDark ? AppColors.cardDark : AppColors.cardLight,
      shadowColor: Colors.black.withValues(alpha: 0.08),
      surfaceTintColor: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 4),
    );
  }

  static ElevatedButtonThemeData _elevatedButtonTheme() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 54),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  static OutlinedButtonThemeData _outlinedButtonTheme() {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size(double.infinity, 54),
        textStyle: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w600),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  static TextButtonThemeData _textButtonTheme() {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        textStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  static InputDecorationTheme _inputDecorationTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return InputDecorationTheme(
      filled: true,
      fillColor: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(
          color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4),
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 1.5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.error, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: isDark ? AppColors.onSurfaceVariantDark : AppColors.onSurfaceVariantLight,
      ),
      hintStyle: GoogleFonts.inter(
        fontSize: 14,
        color: isDark ? const Color(0xFF5A6A5A) : const Color(0xFF8A9A8A),
      ),
      prefixIconColor: isDark ? AppColors.onSurfaceVariantDark : AppColors.outlineLight,
      suffixIconColor: isDark ? AppColors.onSurfaceVariantDark : AppColors.outlineLight,
    );
  }

  static BottomNavigationBarThemeData _bottomNavTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return BottomNavigationBarThemeData(
      type: BottomNavigationBarType.fixed,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: isDark ? const Color(0xFF5A6A5A) : const Color(0xFF8A9A8A),
      elevation: 0,
      selectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600),
      unselectedLabelStyle: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w500),
    );
  }

  static NavigationBarThemeData _navigationBarTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return NavigationBarThemeData(
      height: 72,
      backgroundColor: isDark ? AppColors.cardDark : AppColors.cardLight,
      indicatorColor: AppColors.primaryContainer.withValues(alpha: isDark ? 0.3 : 1.0),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w600,
            color: isDark ? const Color(0xFF74C69D) : AppColors.primary,
          );
        }
        return GoogleFonts.inter(
          fontSize: 11, fontWeight: FontWeight.w500,
          color: isDark ? const Color(0xFF5A6A5A) : const Color(0xFF8A9A8A),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return IconThemeData(
            color: isDark ? const Color(0xFF74C69D) : AppColors.primary, size: 24);
        }
        return IconThemeData(
          color: isDark ? const Color(0xFF5A6A5A) : const Color(0xFF8A9A8A), size: 24);
      }),
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.12),
      surfaceTintColor: Colors.transparent,
    );
  }

  static ChipThemeData _chipTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return ChipThemeData(
      backgroundColor: isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1),
      selectedColor: AppColors.primaryContainer,
      labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      side: BorderSide(
        color: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFD4E4D4),
        width: 1,
      ),
    );
  }
}
