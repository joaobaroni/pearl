import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/core/routing/route_names.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/usecases/delete_home_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_homes_use_case.dart';
import 'package:pearl/features/homes/presentation/widgets/home_form_modal.dart';

class HomesListController extends PearlController with SubjectListener {
  final GetHomesUseCase _getHomes;
  final DeleteHomeUseCase _deleteHome;
  final GetHomeByIdUseCase _getHomeById;

  @override
  final SubjectNotifier subjectNotifier;

  List<HomeModel> homes = [];
  Failure? error;
  bool isLoading = false;

  HomesListController(
    this._getHomes,
    this._deleteHome,
    this._getHomeById,
    this.subjectNotifier,
  );

  @override
  List<Subject> get subjects => [Subject.home];

  @override
  void onSubjectChanged() => loadHomes();

  @override
  void onInit() {
    initSubjectListeners();
    loadHomes();
  }

  @override
  void onDispose() {
    disposeSubjectListeners();
  }

  void loadHomes() {
    isLoading = true;
    error = null;
    notifyListeners();

    _getHomes().fold((failure) => error = failure, (result) => homes = result);

    isLoading = false;
    notifyListeners();
  }

  void onDetailsTap({required BuildContext context, required String id}) =>
      context.goNamed(RouteNames.homeDetail, pathParameters: {'id': id});

  Future<void> openHomeForm(BuildContext context, {HomeModel? home}) async {
    final result = await HomeFormModal.show(context, home: home);
    if (result == null) return;

    _upsertHome(result, existing: home);
    notifyListeners();

    if (!context.mounted) return;
    context.goNamed(RouteNames.homeDetail, pathParameters: {'id': result.id});
  }

  void _upsertHome(HomeModel home, {HomeModel? existing}) {
    if (existing == null) {
      homes.add(home);

      return;
    }

    final index = homes.indexWhere((h) => h.id == existing.id);
    if (index != -1) homes[index] = home;
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
