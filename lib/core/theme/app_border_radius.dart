import 'package:flutter/material.dart';

abstract final class AppBorderRadius {
  static const double radiusXl = 12.0;
  static const double radius2xl = 16.0;
  static const double radius3xl = 24.0;

  static final card = BorderRadius.circular(radius2xl);
  static final input = BorderRadius.circular(radiusXl);
  static const modal = BorderRadius.vertical(
    top: Radius.circular(24),
  );
}
