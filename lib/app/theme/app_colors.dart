import 'package:flutter/material.dart';

/// Central color palette — Clinigoo Pro design tokens.
abstract final class AppColors {
  // ── Primary ──
  static const Color primary = Color(0xFF00A8CC); // Teal — dominant brand
  static const Color primaryDark = Color(0xFF00677E); // Deep teal
  static const Color primaryMid = Color(0xFF00839F); // Mid teal
  static const Color primaryLight = Color(0xFFD9F8FF); // Teal tint / highlight
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFFD9F8FF);
  static const Color onPrimaryContainer = Color(0xFF00677E);

  static const Color secondary = Color(0xFF00839F);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFD3E1E4);
  static const Color onSecondaryContainer = Color(0xFF1A2D35);

  // ── Surfaces ──
  static const Color background = Color(0xFFF8FAFC); // Clean page background
  static const Color surface = Color(0xFFFFFFFF); // Card / panel background
  static const Color surfaceVariant = Color(0xFFF1F5F9);
  static const Color onSurface = Color(0xFF0B1C30);
  static const Color border = Color(0xFFE2E8F0); // Dividers / borders
  static const Color borderStrong = Color(0xFFCCDDE0); // Teal-tinted border
  static const Color borderSage = Color(0xFFD3E1E4);

  // ── Text ──
  static const Color textPrimary = Color(0xFF0B1C30); // Navy — headings
  static const Color textSecondary = Color(0xFF475569); // Slate-600 — body
  static const Color textMuted = Color(0xFF94A3B8); // Slate-400 — subdued
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Semantic ──
  static const Color success = Color(0xFF10B981);
  static const Color successContainer = Color(0xFFD1FAE5);
  static const Color onSuccessContainer = Color(0xFF065F46);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningContainer = Color(0xFFFEF3C7);
  static const Color onWarningContainer = Color(0xFF92400E);

  static const Color error = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFF991B1B);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color errorContainer = Color(0xFFFEE2E2);
  static const Color onErrorContainer = Color(0xFF991B1B);

  static const Color info = Color(0xFF0284C7);
  static const Color infoContainer = Color(0xFFE0F2FE);
  static const Color onInfoContainer = Color(0xFF0369A1);

  static const Color coral = Color(0xFFFF7F7F);
  static const Color onCoral = Color(0xFFFFFFFF);
  static const Color divider = Color(0xFFE2E8F0);
}
