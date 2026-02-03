import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pearl/core/controllers/controller.dart';
import 'package:pearl/core/extensions/list_extensions.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/core/routing/route_names.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/usecases/delete_home_use_case.dart';
import 'package:pearl/domain/usecases/get_homes_use_case.dart';
import 'package:pearl/presentation/views/home_form/home_form_modal.dart';

class HomeController extends Controller with SubjectListener {
  final GetHomesUseCase _getHomes;
  final DeleteHomeUseCase _deleteHome;

  @override
  final SubjectNotifier subjectNotifier;

  List<HomeModel> homes = [];
  Failure? error;
  bool isLoading = false;

  HomeController(this._getHomes, this._deleteHome, this.subjectNotifier);

  @override
  List<Subject> get subjects => [Subject.home];

  @override
  void onSubjectChanged() => loadHomes();

  @override
  void onInit() {
    super.onInit();
    loadHomes();
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
    final isCreating = home == null;
    final result = await HomeFormModal.show(context, home: home);
    if (result == null) return;

    homes.upsert(result, existing: home, test: (h) => h.id == home?.id);
    notifyListeners();

    if (!isCreating || !context.mounted) return;
    context.goNamed(RouteNames.homeDetail, pathParameters: {'id': result.id});
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
