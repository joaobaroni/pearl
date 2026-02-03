import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_border_radius.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/models/home_model.dart';

class HomeCard extends StatefulWidget {
  final HomeModel home;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const HomeCard({
    super.key,
    required this.home,
    this.onTap,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<HomeCard> createState() => _HomeCardState();
}

class _HomeCardState extends State<HomeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppBorderRadius.card,
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
          ),
          boxShadow: AppShadows.sm,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: AppBorderRadius.card,
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: AppBorderRadius.card,
            hoverColor: Colors.transparent,
            splashColor: AppColors.primarySurface,
            highlightColor: AppColors.primarySurface.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(
                            AppBorderRadius.radiusXl,
                          ),
                        ),
                        child: const Icon(
                          LucideIcons.home,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const Spacer(),
                      _CardActions(
                        onEdit: widget.onEdit,
                        onDelete: widget.onDelete,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    widget.home.name,
                    style: textTheme.titleMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    height: 40,
                    child: Text(
                      widget.home.address.formatted,
                      style: textTheme.bodyMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.only(top: AppSpacing.lg),
                    decoration: const BoxDecoration(
                      border: Border(
                        top: BorderSide(color: AppColors.subtleBorder),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.home.assets.length} Assets',
                          style: textTheme.bodyMedium?.copyWith(
                            color: AppColors.disabled,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'View Details',
                              style: textTheme.bodyMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            const Icon(
                              LucideIcons.chevronRight,
                              size: 16,
                              color: AppColors.primary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardActions extends StatelessWidget {
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const _CardActions({this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          _ActionIcon(
            icon: LucideIcons.edit2,
            onTap: onEdit!,
            hoverColor: AppColors.primarySurface,
            iconColor: AppColors.primary,
          ),
        if (onDelete != null)
          _ActionIcon(
            icon: LucideIcons.trash2,
            onTap: onDelete!,
            hoverColor: AppColors.destructiveSurface,
            iconColor: AppColors.destructive,
          ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color hoverColor;
  final Color iconColor;

  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.hoverColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        hoverColor: hoverColor,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Icon(icon, size: 16, color: AppColors.disabled),
        ),
      ),
    );
  }
}
