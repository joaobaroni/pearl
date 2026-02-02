import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/core/routing/route_names.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/usecases/delete_home_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_homes_use_case.dart';
import 'package:pearl/features/homes/presentation/widgets/home_form_modal.dart';

class HomesListController extends PearlController {
  final GetHomesUseCase _getHomes;
  final DeleteHomeUseCase _deleteHome;
  final GetHomeByIdUseCase _getHomeById;

  List<HomeModel> homes = [];
  Failure? error;
  bool isLoading = false;

  HomesListController(this._getHomes, this._deleteHome, this._getHomeById);

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

  Future<void> onDetailsTap({
    required BuildContext context,
    required String id,
  }) async {
    await context.pushNamed(RouteNames.homeDetail, pathParameters: {'id': id});

    final updatedHouse = _getHomeById(id);

    updatedHouse.fold((failure) => error = failure, (result) {
      final index = homes.indexWhere((home) => home.id == id);
      if (index != -1) {
        homes[index] = result;
        notifyListeners();
      }
    });
  }

  Future<void> showHomeForm(BuildContext context, {HomeModel? home}) async {
    final id = await HomeFormModal.show(context, home: home);
    if (id == null) return;

    loadHomes();
    if (!context.mounted) return;
    context.goNamed(RouteNames.homeDetail, pathParameters: {'id': id});
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
