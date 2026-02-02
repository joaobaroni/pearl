import 'package:flutter/material.dart';

import '../di/service_locator.dart' show injector;

/// Base class for all controllers in the application.
///
/// Extends [ChangeNotifier] to provide reactive state management and
/// defines a lifecycle with [onInit] and [onDispose] hooks.
abstract class Controller extends ChangeNotifier {
  Controller() {
    onInit();
  }

  /// Called once during construction to perform initial setup such as
  /// loading data or subscribing to listeners.
  @mustCallSuper
  void onInit() {
    debugPrint('${runtimeType.toString()} initialized.');
  }
}

/// A mixin for [State] classes that binds a [Controller] resolved from the
/// dependency injector and disposes it automatically with the widget.
mixin ViewMixin<T extends StatefulWidget, C extends Controller> on State<T> {
  late final C controller = resolveController();

  /// Resolves the controller of type [C] from the dependency injector.
  ///
  /// Override this to provide a custom resolution strategy (e.g. passing
  /// parameters or using a different scope).
  C resolveController() => injector.get<C>();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
