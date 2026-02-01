import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  static const sm = [
    BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 2,
      offset: Offset(0, 1),
    ),
  ];

  static const md = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];

  static const button = [
    BoxShadow(
      color: AppColors.accentShadow,
      blurRadius: 6,
      offset: Offset(0, 4),
    ),
  ];
}
