import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/dashed_border.dart';

class EmptyAssetsView extends StatelessWidget {
  final VoidCallback? onAddAsset;

  const EmptyAssetsView({super.key, this.onAddAsset});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomPaint(
      foregroundPainter: DashedBorderPainter(
        color: AppColors.border,
        strokeWidth: 2,
        dashLength: 8,
        gapLength: 6,
        borderRadius: AppSpacing.radius2xl,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radius2xl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(LucideIcons.cpu, size: 48, color: AppColors.disabled),
            const SizedBox(height: AppSpacing.md),
            Text(
              'No assets tracked yet',
              style: textTheme.titleMedium?.copyWith(color: AppColors.medium),
            ),
            if (onAddAsset != null) ...[
              const SizedBox(height: AppSpacing.lg),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onAddAsset,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    child: Text(
                      'Add your first asset',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
