import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import 'dashed_border.dart';

class AddPlaceholderCard extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const AddPlaceholderCard({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<AddPlaceholderCard> createState() => _AddPlaceholderCardState();
}

class _AddPlaceholderCardState extends State<AddPlaceholderCard> {
  bool _isHovered = false;

  static const _duration = Duration(milliseconds: 200);
  static const _curve = Curves.easeInOut;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final targetColor = _isHovered ? AppColors.primary : AppColors.border;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: targetColor),
        duration: _duration,
        curve: _curve,
        builder: (context, borderColor, child) {
          return CustomPaint(
            foregroundPainter: DashedBorderPainter(
              color: borderColor ?? AppColors.border,
              strokeWidth: 2,
              dashLength: 8,
              gapLength: 6,
              borderRadius: AppSpacing.radius2xl,
            ),
            child: child,
          );
        },
        child: AnimatedContainer(
          duration: _duration,
          curve: _curve,
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primarySurface.withValues(alpha: 0.3)
                : AppColors.surface,
            borderRadius: AppSpacing.borderRadiusCard,
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: AppSpacing.borderRadiusCard,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: AppSpacing.borderRadiusCard,
              hoverColor: Colors.transparent,
              splashColor: AppColors.primarySurface,
              highlightColor: AppColors.primarySurface.withValues(alpha: 0.5),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedDefaultTextStyle(
                      duration: _duration,
                      curve: _curve,
                      style: TextStyle(
                        color: _isHovered
                            ? AppColors.primary
                            : AppColors.disabled,
                      ),
                      child: Icon(
                        widget.icon,
                        size: 32,
                        color: _isHovered
                            ? AppColors.primary
                            : AppColors.disabled,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AnimatedDefaultTextStyle(
                      duration: _duration,
                      curve: _curve,
                      style:
                          textTheme.bodyLarge?.copyWith(
                            color: _isHovered
                                ? AppColors.primary
                                : AppColors.disabled,
                            fontWeight: FontWeight.w600,
                          ) ??
                          const TextStyle(),
                      child: Text(widget.label),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
