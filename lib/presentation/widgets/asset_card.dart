import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_shadows.dart';
import '../../core/theme/app_spacing.dart';
import '../../domain/models/asset_model.dart';

class AssetCard extends StatefulWidget {
  final AssetModel asset;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const AssetCard({
    super.key,
    required this.asset,
    this.onEdit,
    this.onDelete,
  });

  @override
  State<AssetCard> createState() => _AssetCardState();
}

class _AssetCardState extends State<AssetCard> {
  bool _isHovered = false;

  String _formatDate(DateTime? date) {
    if (date == null) return '—';
    return '${date.month}/${date.day}/${date.year}';
  }

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
          borderRadius: AppSpacing.borderRadiusCard,
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
          ),
          boxShadow: AppShadows.sm,
        ),
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
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                  ),
                  child: Icon(
                    widget.asset.category.icon,
                    color: AppColors.medium,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.asset.name,
                        style: textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.heading,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.asset.category.label.toUpperCase(),
                        style: textTheme.labelSmall?.copyWith(
                          color: AppColors.disabled,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.5,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                _CardActions(
                  onEdit: widget.onEdit,
                  onDelete: widget.onDelete,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _InfoCell(
                    label: 'MANUFACTURER',
                    value: widget.asset.manufacturer.isEmpty
                        ? '—'
                        : widget.asset.manufacturer,
                  ),
                ),
                Expanded(
                  child: _InfoCell(
                    label: 'MODEL',
                    value: widget.asset.model.isEmpty
                        ? '—'
                        : widget.asset.model,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _InfoCell(
                    label: 'INSTALL DATE',
                    value: _formatDate(widget.asset.installDate),
                  ),
                ),
                Expanded(
                  child: _InfoCell(
                    label: 'WARRANTY EXP.',
                    value: _formatDate(widget.asset.warrantyDate),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCell extends StatelessWidget {
  final String label;
  final String value;

  const _InfoCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(
            color: AppColors.disabled,
            fontWeight: FontWeight.w700,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
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
