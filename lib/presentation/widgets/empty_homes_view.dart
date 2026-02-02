import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/dashed_border.dart';

class EmptyHomesView extends StatelessWidget {
  final VoidCallback? onAddHome;

  const EmptyHomesView({super.key, this.onAddHome});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomPaint(
      foregroundPainter: DashedBorderPainter(
        color: AppColors.border,
        strokeWidth: 2,
        dashLength: 8,
        gapLength: 6,
        borderRadius: AppSpacing.radius3xl,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 80),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius3xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.background,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                LucideIcons.home,
                size: 40,
                color: AppColors.disabled,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'Welcome to Home Asset Manager',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.heading,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Start by adding your first home.',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.xxl),
            if (onAddHome != null)
              DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: AppShadows.button,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                ),
                child: Material(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  child: InkWell(
                    onTap: onAddHome,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                    splashColor: AppColors.primaryHover,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.xxxl,
                        vertical: AppSpacing.md,
                      ),
                      child: Text(
                        'Add Your Home',
                        style: textTheme.bodyLarge?.copyWith(
                          color: AppColors.surface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
