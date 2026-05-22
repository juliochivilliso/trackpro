// ==============================================
// AntiGravity GPS — Design System (HUD Theme)
// Shared tokens for the entire Flutter app
// ==============================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Core HUD color palette — matches the Web Dashboard exactly
class HudColors {
  HudColors._();

  // Backgrounds: Deep Dark and Glass
  static const Color deepBlack = Color(0xFF030712); // Tailwind gray-950
  static const Color panelBg = Color(0xB3111827);    // Tailwind gray-900 with 70% opacity
  static const Color cardBg = Color(0x801F2937);      // Tailwind gray-800 with 50% opacity
  static const Color hoverBg = Color(0x333B82F6);     // Blue hover

  // Accents: Vibrant but user-friendly
  static const Color cyan = Color(0xFF3B82F6);        // Changed to Blue to match Web
  static const Color cyanDim = Color(0x4D3B82F6);     
  static const Color green = Color(0xFF22C55E);       // Web Green
  static const Color greenDim = Color(0x4D22C55E);
  static const Color amber = Color(0xFFF59E0B);       // Web Amber
  static const Color amberDim = Color(0x4DF59E0B);
  static const Color red = Color(0xFFEF4444);         // Web Red
  static const Color redDim = Color(0x4DEF4444);

  // Text
  static const Color textPrimary = Color(0xFFF9FAFB); // Tailwind gray-50
  static const Color textSecondary = Color(0xFF9CA3AF); // Tailwind gray-400
  static const Color textDim = Color(0xFF4B5563);     // Tailwind gray-600

  // Borders: Soft glass borders
  static const Color border = Color(0x1FFFFFFF);      // 12% White for glass edge
}

/// Border radius constants
class HudRadius {
  HudRadius._();
  static const double card = 16.0;   // Rounder, more friendly
  static const double sm = 10.0;
  static const double pill = 999.0;
}

/// Text styles using Outfit (primary) and JetBrains Mono (data)
class HudText {
  HudText._();

  static TextStyle heading({double size = 18, Color color = HudColors.textPrimary}) {
    return GoogleFonts.outfit(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
      letterSpacing: 1.0,
    );
  }

  static TextStyle body({double size = 13, Color color = HudColors.textPrimary}) {
    return GoogleFonts.outfit(
      fontSize: size,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }

  static TextStyle label({double size = 10, Color color = HudColors.textSecondary}) {
    return GoogleFonts.outfit(
      fontSize: size,
      fontWeight: FontWeight.w500,
      color: color,
      letterSpacing: 1.0,
    );
  }

  static TextStyle mono({double size = 14, Color color = HudColors.cyan}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: FontWeight.w600,
      color: color,
    );
  }

  static TextStyle monoLarge({double size = 28, Color color = HudColors.cyan}) {
    return GoogleFonts.jetBrainsMono(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}

/// Glass card decoration (glassmorphism)
BoxDecoration hudGlassDecoration({
  Color borderColor = HudColors.border,
  double borderRadius = HudRadius.card,
}) {
  return BoxDecoration(
    color: HudColors.cardBg,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(color: borderColor, width: 1),
  );
}

/// Panel decoration (slightly more opaque)
BoxDecoration hudPanelDecoration({
  Color borderColor = HudColors.border,
}) {
  return BoxDecoration(
    color: HudColors.panelBg,
    borderRadius: BorderRadius.circular(HudRadius.card),
    border: Border.all(color: borderColor, width: 1),
  );
}

/// Build the full app ThemeData
ThemeData buildHudTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: HudColors.deepBlack,
    primaryColor: HudColors.cyan,
    colorScheme: const ColorScheme.dark(
      primary: HudColors.cyan,
      secondary: HudColors.green,
      error: HudColors.red,
      surface: HudColors.panelBg,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: HudColors.panelBg,
      elevation: 0,
      titleTextStyle: HudText.heading(size: 16),
    ),
// cardTheme removed temporarily for SDK compatibility
    textTheme: TextTheme(
      headlineLarge: HudText.heading(size: 24),
      headlineMedium: HudText.heading(size: 18),
      bodyLarge: HudText.body(size: 14),
      bodyMedium: HudText.body(size: 13),
      labelSmall: HudText.label(),
    ),
  );
}
