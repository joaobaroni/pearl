import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pearl/core/controllers/controller.dart';

import '../../../domain/models/asset_model.dart';
import '../../../domain/models/asset_category.dart';
import '../../../domain/models/asset_template.dart';
import '../../../domain/usecases/add_asset_use_case.dart';
import '../../../domain/usecases/params/save_asset_params.dart';
import '../../../domain/usecases/search_asset_templates_use_case.dart';
import '../../../domain/usecases/update_asset_use_case.dart';
import 'enums/asset_form_step.dart';

class AssetFormController extends Controller {
  final AddAssetUseCase _addAsset;
  final UpdateAssetUseCase _updateAsset;
  final SearchAssetTemplatesUseCase _searchTemplates;
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

  late final currentStep = ValueNotifier<AssetFormStep>(
    isEditing ? AssetFormStep.details : AssetFormStep.catalog,
  );
  late final catalogSearchController = TextEditingController();
  late final ValueNotifier<List<AssetTemplate>> filteredCatalog = ValueNotifier(
    [],
  );
  final ValueNotifier<bool> isCatalogLoading = ValueNotifier(false);
  late final ValueNotifier<AssetTemplate?> selectedAssetTemplate =
      ValueNotifier(null);
  Timer? _debounceTimer;

  bool get isEditing => asset != null;

  AssetFormController(
    this._addAsset,
    this._updateAsset,
    this._searchTemplates,
    this.homeId, {
    this.asset,
  });

  @override
  void onInit() {
    super.onInit();
    _loadCatalog('');
  }

  void onCatalogSearchChanged(String query) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      _loadCatalog(query);
    });
  }

  Future<void> _loadCatalog(String query) async {
    isCatalogLoading.value = true;
    final result = await _searchTemplates(query);
    result.fold(
      (_) => filteredCatalog.value = [],
      (items) => filteredCatalog.value = items,
    );
    isCatalogLoading.value = false;
  }

  void selectAssetTemplate(AssetTemplate item) {
    selectedAssetTemplate.value = item;
    selectedCategory.value = item.category;
    nameController.text = item.name;
    currentStep.value = AssetFormStep.details;
  }

  void goBackToCatalog() {
    currentStep.value = AssetFormStep.catalog;
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    catalogSearchController.dispose();
    filteredCatalog.dispose();
    isCatalogLoading.dispose();
    selectedAssetTemplate.dispose();
    currentStep.dispose();
    nameController.dispose();
    manufacturerController.dispose();
    modelController.dispose();
    selectedCategory.dispose();
    installDate.dispose();
    warrantyDate.dispose();
    super.dispose();
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
