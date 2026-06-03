import 'package:flutter/material.dart';

/// Centralized color palette for mobile_bisa
/// Refined for Premium UI/UX
abstract class AppColors {
  // ── Brand (Green Theme - Hijau Daun) ────────────────────────────────────
  static const Color primary = Color(0xFF135122); // #135122
  static const Color primaryLight = Color(0xFFDCFCE7); // Green-100
  static const Color primaryMedium = Color(0xFF1A7A34); // #1A7A34
  static const Color primaryDark = Color(0xFF1A4823); // #1A4823
  static const Color secondary = Color(0xFF059669); // Emerald-600
  static const Color accent = Color(0xFF84CC16); // Lime-500
  static const Color ocean = Color(0xFF2596BE); // #2596BE
  static const Color deepGreen = Color(0xFF135122); // #135122
  static const Color darkerGreen = Color(0xFF1A4823); // #1A4823

  // ── Neutrals (Slate-based for premium feel) ──────────────────────────────
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF0F172A);
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey500 = Color(0xFF64748B);
  static const Color grey600 = Color(0xFF475569);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // ── Semantic ─────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF135122);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // ── GIS map heat scale ───────────────────────────────────────────────────
  static const Color mapVolumeHighest = Color(0xFF064E3B);
  static const Color mapVolumeMid = Color(0xFF34D399);
  static const Color mapVolumeLow = Color(0xFFA7F3D0);
  static const Color mapLandBrown = Color(0xFF795548);

  // ── Forum vote gradients ─────────────────────────────────────────────────
  static const LinearGradient voteUpGradient = LinearGradient(
    colors: [secondary, accent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient voteDownGradient = LinearGradient(
    colors: [Color(0xFFFF416C), Color(0xFFFF4B2B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Background & Surfaces ────────────────────────────────────────────────
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF1F5F9);

  // ── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textHint = Color(0xFF94A3B8);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // ── Shadows ──────────────────────────────────────────────────────────────
  static List<BoxShadow> softShadow = [
    BoxShadow(
      color: const Color(0xFF000000).withOpacity(0.05),
      blurRadius: 15,
      offset: const Offset(0, 5),
    ),
  ];

  static List<BoxShadow> mediumShadow = [
    BoxShadow(
      color: primary.withOpacity(0.15),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  // ── Gradients ────────────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient surfaceGradient = LinearGradient(
    colors: [white, Color(0xFFF8FAFC)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
