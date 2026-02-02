/// Contract for a service locator that registers and resolves dependencies.
///
/// Implementations wrap a concrete DI container (e.g. GetIt) behind this
/// interface so the rest of the application stays decoupled from the container.
abstract class DependencyInjector {
  T get<T extends Object>({
    dynamic param1,
    dynamic param2,
  });

  void registerSingleton<T extends Object>(T instance);

  void registerLazySingleton<T extends Object>(T Function() factory);

  void registerFactory<T extends Object>(T Function() factory);

  void registerFactoryParam<T extends Object, P1, P2>(
    T Function(P1, P2) factory,
  );
}
