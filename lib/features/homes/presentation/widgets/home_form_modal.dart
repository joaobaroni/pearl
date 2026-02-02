import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../core/controllers/pearl_controller.dart';
import '../../../../core/di/service_locator.dart';
import '../../../../core/shell/pearl_modal.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/pearl_text_field.dart';
import '../../domain/models/home.dart';
import '../../domain/models/us_state.dart';
import '../controllers/home_form_controller.dart';

class HomeFormModal extends StatefulWidget {
  final Home? home;

  const HomeFormModal({super.key, this.home});

  static Future<bool?> show(BuildContext context, {Home? home}) {
    return PearlModal.show<bool>(context, child: HomeFormModal(home: home));
  }

  @override
  State<HomeFormModal> createState() => _HomeFormModalState();
}

class _HomeFormModalState extends State<HomeFormModal>
    with PearlControllerMixin<HomeFormModal, HomeFormController> {
  @override
  HomeFormController createController() =>
      getIt<HomeFormController>(param1: widget.home);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ModalHeader(
          title: controller.isEditing ? 'Edit Home' : 'Add New Home',
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
  final HomeFormController controller;
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
            _FieldLabel(text: 'HOME NICKNAME'),
            const SizedBox(height: AppSpacing.sm),
            PearlTextField(
              controller: controller.nameController,
              hintText: 'e.g. Downtown Loft',
              validator: _requiredValidator,
            ),
            const SizedBox(height: AppSpacing.lg),
            _SectionHeader(text: 'PROPERTY ADDRESS'),
            const SizedBox(height: AppSpacing.lg),
            _FieldLabel(text: 'Street Address'),
            const SizedBox(height: AppSpacing.xs),
            PearlTextField(
              controller: controller.streetController,
              hintText: '123 Main St',
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
                      _FieldLabel(text: 'City'),
                      const SizedBox(height: AppSpacing.xs),
                      PearlTextField(
                        controller: controller.cityController,
                        hintText: 'San Francisco',
                        validator: _requiredValidator,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'State'),
                      const SizedBox(height: AppSpacing.xs),
                      ValueListenableBuilder<UsState>(
                        valueListenable: controller.selectedState,
                        builder: (context, state, _) => _StateDropdown(
                          value: state,
                          onChanged: (v) => controller.selectedState.value = v,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                SizedBox(
                  width: 80,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _FieldLabel(text: 'Zip'),
                      const SizedBox(height: AppSpacing.xs),
                      PearlTextField(
                        controller: controller.zipController,
                        hintText: '94105',
                        validator: _requiredValidator,
                      ),
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

class _SectionHeader extends StatelessWidget {
  final String text;

  const _SectionHeader({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.subtleBorder)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: AppColors.disabled,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _StateDropdown extends StatelessWidget {
  final UsState value;
  final ValueChanged<UsState> onChanged;

  const _StateDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UsState>(
          value: value,
          isExpanded: true,
          isDense: false,
          icon: const SizedBox.shrink(),
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.body),
          items: UsState.values
              .map(
                (s) => DropdownMenuItem(value: s, child: Text(s.abbreviation)),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
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
                      'Save Property',
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
