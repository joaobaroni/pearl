import 'dart:ui';

import 'package:flutter/material.dart';

abstract final class AppColors {
  // Primary & Action
  static const primary = Color(0xFF2563EB);
  static const primaryHover = Color(0xFF1D4ED8);
  static const primarySurface = Color(0xFFEFF6FF);
  static const accentShadow = Color(0xFFDBEAFE);

  // Interface (Neutrals)
  static const background = Color(0xFFF8FAFC);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE2E8F0);
  static const subtleBorder = Color(0xFFF1F5F9);
  static const glassmorphism = Color(0xCCFFFFFF); // ~80% white

  // Text
  static const heading = Color(0xFF0F172A);
  static const body = Color(0xFF1E293B);
  static const medium = Color(0xFF475569);
  static const muted = Color(0xFF64748B);
  static const disabled = Color(0xFF94A3B8);

  // Semantic
  static const destructive = Color(0xFFDC2626);
  static const destructiveSurface = Color(0xFFFEF2F2);
}
