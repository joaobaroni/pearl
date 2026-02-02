import 'package:flutter/material.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/core/extensions/list_extensions.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/usecases/delete_asset_use_case.dart';
import 'package:pearl/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/presentation/views/asset_form/asset_form_modal.dart';
import 'package:pearl/presentation/views/home_form/home_form_modal.dart';

class HomeDetailController extends PearlController with SubjectDispatcher {
  final GetHomeByIdUseCase _getHomeById;
  final DeleteAssetUseCase _deleteAsset;

  @override
  final SubjectNotifier subjectNotifier;

  final String homeId;

  HomeModel? home;
  Failure? error;
  bool isLoading = false;

  HomeDetailController(
    this._getHomeById,
    this._deleteAsset,
    this.subjectNotifier,
    this.homeId,
  );

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

  Future<void> openAssetForm(BuildContext context, {AssetModel? asset}) async {
    final result = await AssetFormModal.show(
      context,
      homeId: homeId,
      asset: asset,
    );

    if (result == null) return;

    home?.assets.upsert(
      result,
      existing: asset,
      test: (a) => a.id == asset?.id,
    );
    notifyListeners();
    notifySubject(Subject.home);
  }

  Future<void> openEditHomeForm(BuildContext context) async {
    final result = await HomeFormModal.show(context, home: home);

    if (result == null) return;

    home = result;
    notifyListeners();
    notifySubject(Subject.home);
  }

  Future<void> deleteAsset(String assetId) async {
    final either = await _deleteAsset(homeId, assetId);

    either.fold(
      (failure) {
        error = failure;
        notifyListeners();
      },
      (_) {
        home?.assets.removeWhere((asset) => asset.id == assetId);
        notifyListeners();
        notifySubject(Subject.home);
      },
    );
  }
}
