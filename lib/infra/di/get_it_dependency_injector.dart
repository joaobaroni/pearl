import 'package:get_it/get_it.dart';

import 'package:pearl/core/di/dependency_injector.dart';

class GetItDependencyInjector implements DependencyInjector {
  final GetIt _getIt = GetIt.instance;

  @override
  T get<T extends Object>({dynamic param1, dynamic param2}) {
    return _getIt<T>(param1: param1, param2: param2);
  }

  @override
  void registerSingleton<T extends Object>(T instance) {
    _getIt.registerSingleton<T>(instance);
  }

  @override
  void registerLazySingleton<T extends Object>(T Function() factory) {
    _getIt.registerLazySingleton<T>(factory);
  }

  @override
  void registerFactory<T extends Object>(T Function() factory) {
    _getIt.registerFactory<T>(factory);
  }

  @override
  void registerFactoryParam<T extends Object, P1, P2>(
    T Function(P1, P2) factory,
  ) {
    _getIt.registerFactoryParam<T, P1, P2>(factory);
  }
}
