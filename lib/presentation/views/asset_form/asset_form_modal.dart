import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/controllers/controller.dart';
import '../../../core/di/service_locator.dart' show injector;
import '../../../core/responsive/responsive_extensions.dart';
import '../../widgets/pearl_modal.dart';
import '../../../core/theme/app_border_radius.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../widgets/pearl_text_field.dart';
import '../../../domain/models/asset_model.dart';
import '../../../domain/models/asset_template.dart';
import 'asset_form_controller.dart';
import 'enums/asset_form_step.dart';
import 'widgets/catalog_card_shimmer.dart';

class AssetFormModal extends StatefulWidget {
  final String homeId;
  final AssetModel? asset;

  const AssetFormModal({super.key, required this.homeId, this.asset});

  static Future<AssetModel?> show(
    BuildContext context, {
    required String homeId,
    AssetModel? asset,
  }) {
    return PearlModal.show<AssetModel>(
      context,
      child: AssetFormModal(homeId: homeId, asset: asset),
    );
  }

  @override
  State<AssetFormModal> createState() => _AssetFormModalState();
}

class _AssetFormModalState extends State<AssetFormModal>
    with ViewMixin<AssetFormModal, AssetFormController> {
  @override
  AssetFormController resolveController() => injector.get<AssetFormController>(
    param1: widget.homeId,
    param2: widget.asset,
  );

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AssetFormStep>(
      valueListenable: controller.currentStep,
      builder: (context, step, _) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: step == AssetFormStep.catalog
              ? Column(
                  key: const ValueKey(AssetFormStep.catalog),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ModalHeader(
                      title: 'Select Type',
                      onClose: () => Navigator.of(context).pop(),
                    ),
                    _CatalogContent(controller: controller),
                  ],
                )
              : Column(
                  key: const ValueKey(AssetFormStep.details),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ModalHeader(
                      title: controller.isEditing
                          ? 'Edit Asset'
                          : 'Asset Details',
                      onClose: () => Navigator.of(context).pop(),
                      onBack: controller.isEditing
                          ? null
                          : controller.goBackToCatalog,
                    ),
                    _DetailsContent(
                      controller: controller,
                      onCancel: () => Navigator.of(context).pop(),
                      onSave: () => controller.save(context),
                    ),
                  ],
                ),
        );
      },
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;
  final VoidCallback? onBack;

  const _ModalHeader({required this.title, required this.onClose, this.onBack});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.subtleBorder)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: textTheme.titleLarge),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onClose,
                  borderRadius: BorderRadius.circular(AppSpacing.xxxl),
                  child: const Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Icon(LucideIcons.x, size: 20, color: AppColors.body),
                  ),
                ),
              ),
            ],
          ),
          if (onBack != null) ...[
            const SizedBox(height: AppSpacing.xs),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Material(
                child: InkWell(
                  onTap: onBack,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        LucideIcons.chevronLeft,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        'Back to Catalog',
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CatalogContent extends StatelessWidget {
  final AssetFormController controller;

  const _CatalogContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = context.responsive<int>(mobile: 1, desktop: 2);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 480),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.xxl,
              0,
            ),
            child: PearlTextField(
              controller: controller.catalogSearchController,
              hintText: 'Search catalog...',
              onChanged: controller.onCatalogSearchChanged,
              prefixIcon: const Icon(
                LucideIcons.search,
                size: 16,
                color: AppColors.muted,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Flexible(
            child: ValueListenableBuilder<bool>(
              valueListenable: controller.isCatalogLoading,
              builder: (context, isLoading, _) {
                if (isLoading) {
                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.xxl,
                      0,
                      AppSpacing.xxl,
                      AppSpacing.xxl,
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: AppSpacing.md,
                      mainAxisSpacing: AppSpacing.md,
                      childAspectRatio: 2.4,
                    ),
                    itemCount: 6,
                    itemBuilder: (context, index) => const CatalogCardShimmer(),
                  );
                }
                return ValueListenableBuilder<List<AssetTemplate>>(
                  valueListenable: controller.filteredCatalog,
                  builder: (context, items, _) {
                    if (items.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.xxl,
                        ),
                        child: Text(
                          'No items found',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.muted),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.xxl,
                        0,
                        AppSpacing.xxl,
                        AppSpacing.xxl,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: AppSpacing.md,
                        mainAxisSpacing: AppSpacing.md,
                        childAspectRatio: 2.4,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) => _CatalogCard(
                        item: items[index],
                        onTap: () =>
                            controller.selectAssetTemplate(items[index]),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogCard extends StatefulWidget {
  final AssetTemplate item;
  final VoidCallback onTap;

  const _CatalogCard({required this.item, required this.onTap});

  @override
  State<_CatalogCard> createState() => _CatalogCardState();
}

class _CatalogCardState extends State<_CatalogCard> {
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
          border: Border.all(
            color: _isHovered ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
            hoverColor: Colors.transparent,
            splashColor: AppColors.primarySurface,
            highlightColor: AppColors.primarySurface.withValues(alpha: 0.5),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                    child: Icon(
                      widget.item.icon,
                      size: 20,
                      color: _isHovered ? AppColors.primary : AppColors.medium,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.item.name,
                          style: textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.category.label.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                            color: AppColors.muted,
                            fontWeight: FontWeight.w700,
                            fontSize: 10,
                            letterSpacing: 1,
                          ),
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

class _SelectedTypeCard extends StatelessWidget {
  final AssetTemplate item;

  const _SelectedTypeCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
        border: Border.all(color: AppColors.accentShadow),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Icon(item.icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TYPE',
                style: textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 10,
                  letterSpacing: 1,
                ),
              ),
              Text(
                item.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.heading,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DetailsContent extends StatelessWidget {
  final AssetFormController controller;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _DetailsContent({
    required this.controller,
    required this.onCancel,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder<AssetTemplate?>(
              valueListenable: controller.selectedAssetTemplate,
              builder: (context, item, _) {
                if (item == null) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.lg),
                  child: _SelectedTypeCard(item: item),
                );
              },
            ),
            _FieldLabel(text: 'ASSET NAME'),
            const SizedBox(height: AppSpacing.sm),
            PearlTextField(
              controller: controller.nameController,
              hintText: 'e.g. Master Bedroom AC',
              validator: _requiredValidator,
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'MANUFACTURER'),
                      const SizedBox(height: AppSpacing.xs),
                      PearlTextField(
                        controller: controller.manufacturerController,
                        hintText: 'e.g. LG',
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'MODEL'),
                      const SizedBox(height: AppSpacing.xs),
                      PearlTextField(
                        controller: controller.modelController,
                        hintText: 'e.g. TH-55X900L',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'INSTALL DATE'),
                      const SizedBox(height: AppSpacing.xs),
                      _DateField(dateNotifier: controller.installDate),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'WARRANTY EXPIRATION'),
                      const SizedBox(height: AppSpacing.xs),
                      _DateField(dateNotifier: controller.warrantyDate),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            _ModalActions(onCancel: onCancel, onSave: onSave),
          ],
        ),
      ),
    );
  }
}

String? _requiredValidator(String? value) =>
    (value == null || value.trim().isEmpty) ? '' : null;

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: AppColors.muted,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  final ValueNotifier<DateTime?> dateNotifier;

  const _DateField({required this.dateNotifier});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<DateTime?>(
      valueListenable: dateNotifier,
      builder: (context, date, _) {
        return Material(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: date ?? DateTime.now(),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) {
                dateNotifier.value = picked;
              }
            },
            borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md + 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
              ),
              child: Text(
                date != null
                    ? '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}'
                    : 'Select date',
                style: textTheme.bodyMedium?.copyWith(
                  color: date != null ? AppColors.body : AppColors.disabled,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ModalActions extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _ModalActions({required this.onCancel, required this.onSave});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
            child: InkWell(
              onTap: onCancel,
              borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                child: Center(
                  child: Text(
                    'Cancel',
                    style: textTheme.bodyLarge?.copyWith(
                      color: AppColors.medium,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: AppShadows.button,
              borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
            ),
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
              child: InkWell(
                onTap: onSave,
                borderRadius: BorderRadius.circular(AppBorderRadius.radiusXl),
                splashColor: AppColors.primaryHover,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.lg),
                  child: Center(
                    child: Text(
                      'Save Asset',
                      style: textTheme.bodyLarge?.copyWith(
                        color: AppColors.surface,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
