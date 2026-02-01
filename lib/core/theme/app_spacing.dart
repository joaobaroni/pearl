import 'package:flutter/material.dart';

/// Spacing tokens based on a 4px scale.
abstract final class AppSpacing {
  // Base unit
  static const double unit = 4.0;

  // Named sizes
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double xxl = 24.0;
  static const double xxxl = 32.0;

  // Padding
  static const double paddingMobile = 16.0;
  static const double paddingDesktop = 24.0;

  // Gaps
  static const double gapSmall = 8.0;
  static const double gapMedium = 12.0;
  static const double gapLarge = 16.0;

  // Max content width
  static const double maxContentWidth = 1024.0;

  // Border radius
  static const double radiusXl = 12.0;
  static const double radius2xl = 16.0;
  static const double radius3xl = 24.0;

  // Pre-built BorderRadius
  static final borderRadiusCard = BorderRadius.circular(radius2xl);
  static final borderRadiusInput = BorderRadius.circular(radiusXl);
  static final borderRadiusModal = const BorderRadius.vertical(
    top: Radius.circular(24),
  );
}
