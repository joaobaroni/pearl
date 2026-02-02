import 'package:flutter/material.dart';
import 'package:pearl/core/controllers/controller.dart';

import '../../../domain/models/asset_model.dart';
import '../../../domain/models/asset_category.dart';
import '../../../domain/usecases/add_asset_use_case.dart';
import '../../../domain/usecases/params/save_asset_params.dart';
import '../../../domain/usecases/update_asset_use_case.dart';

class AssetFormController extends Controller {
  final AddAssetUseCase _addAsset;
  final UpdateAssetUseCase _updateAsset;
  final String homeId;
  final AssetModel? asset;

  late final nameController = TextEditingController(text: asset?.name ?? '');
  late final manufacturerController = TextEditingController(
    text: asset?.manufacturer ?? '',
  );
  late final modelController = TextEditingController(text: asset?.model ?? '');

  final formKey = GlobalKey<FormState>();

  late final ValueNotifier<AssetCategory> selectedCategory = ValueNotifier(
    asset?.category ?? AssetCategory.appliances,
  );
  late final ValueNotifier<DateTime?> installDate = ValueNotifier(
    asset?.installDate,
  );
  late final ValueNotifier<DateTime?> warrantyDate = ValueNotifier(
    asset?.warrantyDate,
  );

  bool get isEditing => asset != null;

  AssetFormController(
    this._addAsset,
    this._updateAsset,
    this.homeId, {
    this.asset,
  });

  @override
  void onInit() {}

  @override
  void onDispose() {
    nameController.dispose();
    manufacturerController.dispose();
    modelController.dispose();
    selectedCategory.dispose();
    installDate.dispose();
    warrantyDate.dispose();
  }

  Future<void> save(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final params = SaveAssetParams(
      name: nameController.text.trim(),
      category: selectedCategory.value,
      manufacturer: manufacturerController.text.trim(),
      model: modelController.text.trim(),
      installDate: installDate.value,
      warrantyDate: warrantyDate.value,
    );

    final either = isEditing
        ? await _updateAsset(homeId, asset!.id, params)
        : await _addAsset(homeId, params);

    if (!context.mounted) return;

    either.fold(
      (_) => Navigator.of(context).pop(),
      (asset) => Navigator.of(context).pop(asset),
    );
  }
}
