import 'package:flutter/material.dart';

import '../di/service_locator.dart';

abstract class PearlController extends ChangeNotifier {
  PearlController() {
    onInit();
  }

  void onInit();

  void onDispose() {}

  @override
  void dispose() {
    onDispose();
    super.dispose();
  }
}

mixin PearlControllerMixin<T extends StatefulWidget,
    C extends PearlController> on State<T> {
  late final C controller = createController();

  C createController() => getIt<C>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
