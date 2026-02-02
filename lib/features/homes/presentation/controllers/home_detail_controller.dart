import 'package:flutter/material.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/asset_model.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/usecases/delete_asset_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/features/homes/presentation/widgets/asset_form_modal.dart';
import 'package:pearl/features/homes/presentation/widgets/home_form_modal.dart';

class HomeDetailController extends PearlController {
  final GetHomeByIdUseCase _getHomeById;
  final DeleteAssetUseCase _deleteAsset;
  final String homeId;

  HomeModel? home;
  Failure? error;
  bool isLoading = false;

  HomeDetailController(this._getHomeById, this._deleteAsset, this.homeId);

  @override
  void onInit() {
    loadHome();
  }

  void loadHome() {
    isLoading = true;
    error = null;
    notifyListeners();

    _getHomeById(
      homeId,
    ).fold((failure) => error = failure, (result) => home = result);

    isLoading = false;
    notifyListeners();
  }

  Future<void> showAssetForm(BuildContext context, {AssetModel? asset}) async {
    final saved = await AssetFormModal.show(
      context,
      homeId: homeId,
      asset: asset,
    );
    if (saved == true) loadHome();
  }

  Future<void> showEditHomeForm(BuildContext context) async {
    final result = await HomeFormModal.show(context, home: home);
    if (result != null) loadHome();
  }

  Future<void> deleteAsset(String assetId) async {
    final either = await _deleteAsset(homeId, assetId);
    either.fold(
      (failure) {
        error = failure;
        notifyListeners();
      },
      (_) => loadHome(),
    );
  }
}
