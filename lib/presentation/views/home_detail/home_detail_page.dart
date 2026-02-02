import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../core/controllers/controller.dart';
import '../../../core/di/service_locator.dart' show injector;
import '../../../core/responsive/responsive.dart';
import '../../widgets/pearl_app_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/models/asset_model.dart';
import 'home_detail_controller.dart';
import '../../widgets/asset_card.dart';
import '../../widgets/empty_assets_view.dart';

class HomeDetailPage extends StatefulWidget {
  const HomeDetailPage({super.key, required this.homeId});

  final String homeId;

  @override
  State<HomeDetailPage> createState() => _HomeDetailPageState();
}

class _HomeDetailPageState extends State<HomeDetailPage>
    with ViewMixin<HomeDetailPage, HomeDetailController> {
  @override
  HomeDetailController createController() =>
      injector.get<HomeDetailController>(param1: widget.homeId);

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: PearlAppBar(
            title: controller.home?.name ?? '',
            leading: IconButton(
              icon: const Icon(LucideIcons.chevronLeft, color: AppColors.body),
              onPressed: () => context.pop(),
            ),
            actionLabel: 'Add Asset',
            onActionPressed: () => controller.openAssetForm(context),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final home = controller.home;
                if (home == null) {
                  return const Center(child: Text('Home not found'));
                }

                return _HomeDetailBody(
                  address: home.address.formatted,
                  assets: home.assets,
                  onEditHome: () => controller.openEditHomeForm(context),
                  onAddAsset: () => controller.openAssetForm(context),
                  onEditAsset: (asset) =>
                      controller.openAssetForm(context, asset: asset),
                  onDeleteAsset: (asset) => controller.deleteAsset(asset.id),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _HomeDetailBody extends StatelessWidget {
  final String address;
  final List<AssetModel> assets;
  final VoidCallback onEditHome;
  final VoidCallback onAddAsset;
  final ValueChanged<AssetModel> onEditAsset;
  final ValueChanged<AssetModel> onDeleteAsset;

  const _HomeDetailBody({
    required this.address,
    required this.assets,
    required this.onEditHome,
    required this.onAddAsset,
    required this.onEditAsset,
    required this.onDeleteAsset,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive<double>(
      mobile: AppSpacing.paddingMobile,
      desktop: AppSpacing.paddingDesktop,
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: AppSpacing.xxl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: AppSpacing.maxContentWidth,
          ),
          child: Column(
            children: [
              _AddressCard(address: address, onEdit: onEditHome),
              const SizedBox(height: AppSpacing.xxl),
              if (assets.isEmpty)
                EmptyAssetsView(onAddAsset: onAddAsset)
              else
                _AssetsGrid(
                  assets: assets,
                  onEdit: onEditAsset,
                  onDelete: onDeleteAsset,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final String address;
  final VoidCallback onEdit;

  const _AddressCard({required this.address, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppSpacing.borderRadiusCard,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.mapPin,
                      size: 14,
                      color: AppColors.muted,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      'Property Address',
                      style: textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  address,
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.heading,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          OutlinedButton(
            onPressed: onEdit,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.body,
              side: const BorderSide(color: AppColors.border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
            ),
            child: Text(
              'Edit Home',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetsGrid extends StatelessWidget {
  final List<AssetModel> assets;
  final ValueChanged<AssetModel> onEdit;
  final ValueChanged<AssetModel> onDelete;

  const _AssetsGrid({
    required this.assets,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final crossAxisCount = context.responsive<int>(mobile: 1, desktop: 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
        mainAxisExtent: 200,
      ),
      itemCount: assets.length,
      itemBuilder: (context, index) {
        final asset = assets[index];
        return AssetCard(
          asset: asset,
          onEdit: () => onEdit(asset),
          onDelete: () => onDelete(asset),
        );
      },
    );
  }
}
