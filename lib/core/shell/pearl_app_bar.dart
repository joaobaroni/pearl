import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../responsive/responsive.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

class PearlAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PearlAppBar({
    super.key,
    required this.title,
    this.leading,
    this.actionLabel,
    this.onActionPressed,
  });

  final String title;
  final Widget? leading;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(color: AppColors.glassmorphism),
        ),
      ),
      shape: const Border(
        bottom: BorderSide(color: AppColors.border, width: 1),
      ),
      leading: leading ??
          const Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Icon(LucideIcons.home, color: AppColors.primary),
          ),
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: Text(
          title,
          key: ValueKey(title),
          style: const TextStyle(
            color: AppColors.body,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      actions: [
        if (actionLabel != null)
          Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: _ActionButton(
              label: actionLabel!,
              onPressed: onActionPressed,
            ),
          ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    this.onPressed,
  });

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    if (context.isMobile) {
      return IconButton(
        onPressed: onPressed,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          shape: const CircleBorder(),
        ),
        icon: const Icon(LucideIcons.plus, size: 20),
      );
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(LucideIcons.plus, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        ),
        splashFactory: InkRipple.splashFactory,
        overlayColor: AppColors.primarySurface,
      ),
    );
  }
}
