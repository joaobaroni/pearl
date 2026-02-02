import 'package:flutter/material.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';

import '../../../domain/models/address_model.dart';
import '../../../domain/models/home_model.dart';
import '../../../domain/models/us_state.dart';
import '../../../domain/usecases/create_home_use_case.dart';
import '../../../domain/usecases/params/save_home_params.dart';
import '../../../domain/usecases/update_home_use_case.dart';

class HomeFormController extends PearlController {
  final CreateHomeUseCase _createHome;
  final UpdateHomeUseCase _updateHome;
  final HomeModel? home;

  late final nameController = TextEditingController(text: home?.name ?? '');
  late final streetController = TextEditingController(
    text: home?.address.street ?? '',
  );
  late final cityController = TextEditingController(
    text: home?.address.city ?? '',
  );
  late final zipController = TextEditingController(
    text: home?.address.zip ?? '',
  );

  final formKey = GlobalKey<FormState>();

  late final ValueNotifier<UsState> selectedState = ValueNotifier(
    home?.address.state ?? UsState.ca,
  );

  bool get isEditing => home != null;

  HomeFormController(this._createHome, this._updateHome, {this.home});

  @override
  void onInit() {}

  @override
  void onDispose() {
    nameController.dispose();
    streetController.dispose();
    cityController.dispose();
    zipController.dispose();
    selectedState.dispose();
  }

  Future<void> save(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;

    final params = SaveHomeParams(
      name: nameController.text.trim(),
      address: AddressModel(
        street: streetController.text.trim(),
        city: cityController.text.trim(),
        state: selectedState.value,
        zip: zipController.text.trim(),
      ),
    );

    if (!context.mounted) return;

    final either = isEditing
        ? await _updateHome(home!.id, params)
        : await _createHome(params);

    if (!context.mounted) return;

    either.fold(
      (_) => Navigator.of(context).pop(),
      (home) => Navigator.of(context).pop(home),
    );
  }
}
