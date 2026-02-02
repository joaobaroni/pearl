import 'package:flutter/material.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/home.dart';
import 'package:pearl/features/homes/domain/usecases/delete_home.dart';
import 'package:pearl/features/homes/domain/usecases/get_homes.dart';
import 'package:pearl/features/homes/presentation/widgets/home_form_modal.dart';

class HomesListController extends PearlController {
  final GetHomes _getHomes;
  final DeleteHome _deleteHome;

  List<Home> homes = [];
  Failure? error;
  bool isLoading = false;

  HomesListController(this._getHomes, this._deleteHome);

  @override
  void onInit() {
    loadHomes();
  }

  @override
  void onDispose() {}

  void loadHomes() {
    isLoading = true;
    error = null;
    notifyListeners();

    _getHomes().fold((failure) => error = failure, (result) => homes = result);

    isLoading = false;
    notifyListeners();
  }

  Future<void> showHomeForm(BuildContext context, {Home? home}) async {
    final saved = await HomeFormModal.show(context, home: home);
    if (saved == true) loadHomes();
  }

  Future<void> deleteHome(String id) async {
    final either = await _deleteHome(id);
    either.fold(
      (failure) => error = failure,
      (_) => homes.removeWhere((home) => home.id == id),
    );
    notifyListeners();
  }
}
