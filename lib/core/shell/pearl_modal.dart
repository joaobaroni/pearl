import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

class PearlModal extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const PearlModal({
    super.key,
    required this.child,
    this.maxWidth = 512,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    double maxWidth = 512,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: Colors.transparent,
      builder: (_) => PearlModal(
        maxWidth: maxWidth,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
        child: Container(
          color: const Color(0x660F172A),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: GestureDetector(
            onTap: () {},
            child: Material(
              color: Colors.transparent,
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(AppSpacing.radius2xl),
                    boxShadow: AppShadows.md,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
