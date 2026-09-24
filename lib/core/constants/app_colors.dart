import 'package:flutter/material.dart';

/// Design System - Warna aplikasi TKA Test.
/// Diambil dari spesifikasi prompt + screenshot referensi.
class AppColors {
  AppColors._();

  // Brand
  static const Color primaryBlue = Color(0xFF3B7DD8);
  static const Color primaryDark = Color(0xFF2C5F9E);
  static const Color primaryLight = Color(0xFFE3F2FD);

  // Background & surface
  static const Color background = Color(0xFFF0F4F8);
  static const Color cardWhite = Color(0xFFFFFFFF);
  static const Color infoGreyBox = Color(0xFFF1F3F5);

  // Text
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);

  // Accents
  static const Color accentYellow = Color(0xFFFFD93D);
  static const Color accentGreen = Color(0xFF4CAF50);
  static const Color accentPink = Color(0xFFE91E8C);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentPurple = Color(0xFF7C4DFF);
  static const Color diamondPink = Color(0xFFE91E63);
  static const Color coinGold = Color(0xFFFFB300);

  // Tags
  static const Color freeTag = Color(0xFFE3F2FD);
  static const Color freeTagText = Color(0xFF1976D2);
  static const Color premiumTag = Color(0xFFE8F5E9);
  static const Color premiumTagText = Color(0xFF2E7D32);

  // Materi colors
  static const Color fisika = Color(0xFFF48FB1);
  static const Color kimia = Color(0xFFFFB74D);
  static const Color biologi = Color(0xFF81C784);
  static const Color matematika = Color(0xFF64B5F6);
  static const Color sejarah = Color(0xFFD7CCC8);
  static const Color literasi = Color(0xFF9575CD);
  static const Color bindo = Color(0xFFEF5350);

  // Badge
  static const Color badgeRed = Color(0xFFE53935);
  static const Color liveOrange = Color(0xFFFF6B35);

  // Search & field
  static const Color searchBg = Color(0xFFF1F3F5);
  static const Color dropdownBg = Color(0xFFE3F2FD);

  // Shadow
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.06),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
