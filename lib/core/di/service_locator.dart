import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:pearl/features/homes/data/dtos/home_hive_dto.dart';
import 'package:pearl/features/homes/data/repositories/home_repository_impl.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';
import 'package:pearl/features/homes/domain/usecases/delete_home.dart';
import 'package:pearl/features/homes/domain/usecases/get_home_by_id.dart';
import 'package:pearl/features/homes/domain/usecases/get_homes.dart';
import 'package:pearl/features/homes/domain/usecases/create_home.dart';
import 'package:pearl/features/homes/domain/usecases/update_home.dart';
import 'package:pearl/features/homes/presentation/controllers/home_form_controller.dart';
import 'package:pearl/features/homes/presentation/controllers/homes_list_controller.dart';
import 'package:pearl/features/homes/domain/models/home.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final homeBox = await Hive.openBox<HomeHiveDto>('homes');
  getIt.registerSingleton<Box<HomeHiveDto>>(homeBox);

  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<Box<HomeHiveDto>>()),
  );

  getIt.registerLazySingleton(() => GetHomes(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => GetHomeById(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => CreateHome(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => UpdateHome(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => DeleteHome(getIt<HomeRepository>()));

  getIt.registerFactory(
    () => HomesListController(
      getIt<GetHomes>(),
      getIt<DeleteHome>(),
    ),
  );
  getIt.registerFactoryParam<HomeFormController, Home?, void>(
    (home, _) => HomeFormController(
      getIt<CreateHome>(),
      getIt<UpdateHome>(),
      home: home,
    ),
  );
}
