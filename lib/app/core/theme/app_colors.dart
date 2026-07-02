import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Greens
  static const primary = Color(0xFF2D6A4F);
  static const primaryDark = Color(0xFF1B4332);
  static const primaryLight = Color(0xFF52B788);
  static const primaryContainer = Color(0xFFB7E4C7);
  static const onPrimaryContainer = Color(0xFF002111);

  // Accent
  static const secondary = Color(0xFF52B788);
  static const secondaryContainer = Color(0xFFCCF0DC);
  static const tertiary = Color(0xFFF4A261);
  static const tertiaryContainer = Color(0xFFFFDDC1);
  static const onTertiary = Color(0xFF3F1E00);

  // Earth
  static const earth = Color(0xFF8B5E3C);
  static const earthLight = Color(0xFFD4A574);
  static const earthContainer = Color(0xFFF5E6D3);

  // Status
  static const success = Color(0xFF40916C);
  static const successLight = Color(0xFFD8F3DC);
  static const warning = Color(0xFFE9C46A);
  static const warningLight = Color(0xFFFFF3CD);
  static const error = Color(0xFFBA1A1A);
  static const errorLight = Color(0xFFFFDAD6);
  static const info = Color(0xFF2196F3);
  static const infoLight = Color(0xFFE3F2FD);

  // Neutral Light
  static const backgroundLight = Color(0xFFF6FBF7);
  static const surfaceLight = Color(0xFFFAFDFA);
  static const surfaceVariantLight = Color(0xFFDCE5DC);
  static const outlineLight = Color(0xFF6C736C);
  static const onSurfaceLight = Color(0xFF1A1C1A);
  static const onSurfaceVariantLight = Color(0xFF3F4A3F);

  // Neutral Dark
  static const backgroundDark = Color(0xFF0C1610);
  static const surfaceDark = Color(0xFF111E14);
  static const surfaceVariantDark = Color(0xFF1E2E20);
  static const outlineDark = Color(0xFF8A9489);
  static const onSurfaceDark = Color(0xFFE1E4DF);
  static const onSurfaceVariantDark = Color(0xFFBCC5BB);

  // Elevation overlays (cards)
  static const cardLight = Color(0xFFFFFFFF);
  static const cardDark = Color(0xFF192B1C);
  static const glassFill = Color(0x1A2D6A4F);
  static const glassBorder = Color(0x332D6A4F);

  // Gradients
  static const gradientStart = Color(0xFF2D6A4F);
  static const gradientEnd = Color(0xFF52B788);
  static const gradientSurface = Color(0xFFB7E4C7);

  static LinearGradient get primaryGradient => const LinearGradient(
        colors: [gradientStart, gradientEnd],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  static LinearGradient get heroGradient => const LinearGradient(
        colors: [Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF40916C)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );

  static LinearGradient get cardGradient => const LinearGradient(
        colors: [Color(0xFF2D6A4F), Color(0xFF52B788)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
}
