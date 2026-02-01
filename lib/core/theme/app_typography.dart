import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static TextTheme get textTheme {
    final base = GoogleFonts.interTextTheme();
    return base.copyWith(
      // Title (xl) — 20px Bold
      titleLarge: base.titleLarge?.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.body,
      ),
      // Header (lg) — 18px Bold
      titleMedium: base.titleMedium?.copyWith(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: AppColors.body,
      ),
      // Body (base) — 16px Medium
      bodyLarge: base.bodyLarge?.copyWith(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.body,
      ),
      // Small (sm) — 14px Normal/Medium
      bodyMedium: base.bodyMedium?.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.muted,
      ),
      // Label (xs) — 12px Bold
      labelSmall: base.labelSmall?.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: AppColors.disabled,
      ),
      // Uppercase — 10px Bold, wide letter spacing
      labelLarge: base.labelLarge?.copyWith(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.disabled,
        letterSpacing: 1.5,
      ),
    );
  }
}
