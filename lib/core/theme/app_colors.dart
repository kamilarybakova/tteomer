import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  /* =======================
   * Base backgrounds
   * ======================= */

  static const Color backgroundPrimary = Color(0xFF0E0F14);
  static const Color backgroundSecondary = Color(0xFF161822);
  static const Color backgroundCard = Color(0xFF1E2130);
  static const Color backgroundNav = Color(0xFF11131A);

  /* =======================
   * Text colors
   * ======================= */

  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF3A3A3A);
  static const Color textDisabled = Color(0xFF88898F);

  /* =======================
   * Brand / Accent
   * ======================= */

  static const Color accent = Color(0xFF4861EB);
  static const Color accentSoft = Color(0xFFA5A5FF);
  static const Color accentDark = Color(0xFF5B5BE6);

  /* =======================
   * Semantic colors
   * ======================= */

  static const Color success = Color(0xFF3DDC97);
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = Color(0xFFFFB703);
  static const Color info = Color(0xFF5E9BFF);

  /* =======================
   * Word learning states
   * ======================= */

  static const Color wordKnown = success;
  static const Color wordLearning = accent;
  static const Color wordDifficult = error;
  static const Color wordNew = info;

  /* =======================
   * UI elements
   * ======================= */

  static const Color divider = Color(0xFF2A2E42);
  static const Color border = Color(0xFF2F334A);

  static const Color progressBackground = Color(0xFF2A2E42);

  /* =======================
   * Overlays & effects
   * ======================= */

  static const Color overlay = Color(0x99000000); // black 60%
  static const Color aiGlow = Color(0x667C7CFF); // violet glow
}
