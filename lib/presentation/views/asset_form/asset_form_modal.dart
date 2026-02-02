import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/controllers/controller.dart';
import '../../../core/di/service_locator.dart' show injector;
import '../../widgets/pearl_modal.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../widgets/pearl_text_field.dart';
import '../../../domain/models/asset_model.dart';
import '../../../domain/models/asset_category.dart';
import 'asset_form_controller.dart';

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
  AssetFormController createController() => injector.get<AssetFormController>(
    param1: widget.homeId,
    param2: widget.asset,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ModalHeader(
          title: controller.isEditing ? 'Edit Asset' : 'Add New Asset',
          onClose: () => Navigator.of(context).pop(),
        ),
        _ModalForm(
          controller: controller,
          onCancel: () => Navigator.of(context).pop(),
          onSave: () => controller.save(context),
        ),
      ],
    );
  }
}

class _ModalHeader extends StatelessWidget {
  final String title;
  final VoidCallback onClose;

  const _ModalHeader({required this.title, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.subtleBorder)),
      ),
      child: Row(
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
    );
  }
}

class _ModalForm extends StatelessWidget {
  final AssetFormController controller;
  final VoidCallback onCancel;
  final VoidCallback onSave;

  const _ModalForm({
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
            _FieldLabel(text: 'CATEGORY'),
            const SizedBox(height: AppSpacing.sm),
            _CategorySelector(controller: controller),
            const SizedBox(height: AppSpacing.lg),
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

class _CategorySelector extends StatelessWidget {
  final AssetFormController controller;

  const _CategorySelector({required this.controller});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ValueListenableBuilder<AssetCategory>(
      valueListenable: controller.selectedCategory,
      builder: (context, selected, _) {
        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: AssetCategory.values.map((cat) {
            final isSelected = selected == cat;
            return Material(
              color: isSelected ? AppColors.primary : AppColors.surface,
              borderRadius: BorderRadius.circular(AppSpacing.xxxl),
              child: InkWell(
                onTap: () => controller.selectedCategory.value = cat,
                borderRadius: BorderRadius.circular(AppSpacing.xxxl),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.lg,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppSpacing.xxxl),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.border,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        cat.icon,
                        size: 16,
                        color: isSelected
                            ? AppColors.surface
                            : AppColors.medium,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(
                        cat.label,
                        style: textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                          color: isSelected
                              ? AppColors.surface
                              : AppColors.medium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
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
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
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
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md + 2,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              ),
              child: Text(
                date != null
                    ? '${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}/${date.year}'
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
            borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            child: InkWell(
              onTap: onCancel,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
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
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
            ),
            child: Material(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              child: InkWell(
                onTap: onSave,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
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
