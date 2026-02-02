import 'package:flutter/material.dart';
import 'package:pearl/core/controllers/pearl_controller.dart';

import '../../domain/models/address.dart';
import '../../domain/models/home.dart';
import '../../domain/models/us_state.dart';
import '../../domain/usecases/create_home.dart';
import '../../domain/usecases/params/save_home_params.dart';
import '../../domain/usecases/update_home.dart';

class HomeFormController extends PearlController {
  final CreateHome _createHome;
  final UpdateHome _updateHome;
  final Home? home;

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
      address: Address(
        street: streetController.text.trim(),
        city: cityController.text.trim(),
        state: selectedState.value,
        zip: zipController.text.trim(),
      ),
    );

    final either = isEditing
        ? await _updateHome(home!.id, params)
        : await _createHome(params);

    if (!context.mounted) return;
    either.fold(
      (_) => Navigator.of(context).pop(false),
      (_) => Navigator.of(context).pop(true),
    );
  }
}
