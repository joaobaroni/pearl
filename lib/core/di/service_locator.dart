import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';

import 'package:pearl/features/homes/data/dtos/asset_hive_dto.dart';
import 'package:pearl/features/homes/data/dtos/home_hive_dto.dart';
import 'package:pearl/features/homes/data/repositories/asset_repository_impl.dart';
import 'package:pearl/features/homes/data/repositories/home_repository_impl.dart';
import 'package:pearl/features/homes/domain/models/asset_model.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/repositories/asset_repository.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';
import 'package:pearl/features/homes/domain/usecases/add_asset_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/delete_asset_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/delete_home_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/get_homes_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/create_home_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/update_asset_use_case.dart';
import 'package:pearl/features/homes/domain/usecases/update_home_use_case.dart';
import 'package:pearl/features/homes/presentation/controllers/asset_form_controller.dart';
import 'package:pearl/features/homes/presentation/controllers/home_detail_controller.dart';
import 'package:pearl/features/homes/presentation/controllers/home_form_controller.dart';
import 'package:pearl/features/homes/presentation/controllers/homes_list_controller.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  final homeBox = await Hive.openBox<HomeHiveDto>('homes');
  final assetBox = await Hive.openBox<AssetHiveDto>('assets');
  getIt.registerSingleton<Box<HomeHiveDto>>(homeBox);
  getIt.registerSingleton<Box<AssetHiveDto>>(assetBox);

  // Repositories
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      getIt<Box<HomeHiveDto>>(),
      getIt<Box<AssetHiveDto>>(),
    ),
  );
  getIt.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(getIt<Box<AssetHiveDto>>()),
  );

  // Home usecases
  getIt.registerLazySingleton(() => GetHomesUseCase(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => GetHomeByIdUseCase(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => CreateHomeUseCase(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => UpdateHomeUseCase(getIt<HomeRepository>()));
  getIt.registerLazySingleton(() => DeleteHomeUseCase(getIt<HomeRepository>()));

  // Asset usecases
  getIt.registerLazySingleton(() => AddAssetUseCase(getIt<AssetRepository>()));
  getIt.registerLazySingleton(() => UpdateAssetUseCase(getIt<AssetRepository>()));
  getIt.registerLazySingleton(() => DeleteAssetUseCase(getIt<AssetRepository>()));

  // Controllers
  getIt.registerFactory(
    () => HomesListController(
      getIt<GetHomesUseCase>(),
      getIt<DeleteHomeUseCase>(),
      getIt<GetHomeByIdUseCase>(),
    ),
  );
  getIt.registerFactoryParam<HomeFormController, HomeModel?, void>(
    (home, _) => HomeFormController(
      getIt<CreateHomeUseCase>(),
      getIt<UpdateHomeUseCase>(),
      home: home,
    ),
  );
  getIt.registerFactoryParam<HomeDetailController, String, void>(
    (homeId, _) => HomeDetailController(
      getIt<GetHomeByIdUseCase>(),
      getIt<DeleteAssetUseCase>(),
      homeId,
    ),
  );
  getIt.registerFactoryParam<AssetFormController, String, AssetModel?>(
    (homeId, asset) => AssetFormController(
      getIt<AddAssetUseCase>(),
      getIt<UpdateAssetUseCase>(),
      homeId,
      asset: asset,
    ),
  );
}
