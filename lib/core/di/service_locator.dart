import 'package:hive/hive.dart';

import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/dtos/home_hive_dto.dart';
import 'package:pearl/data/repositories/asset_repository_impl.dart';
import 'package:pearl/data/repositories/asset_template_repository_impl.dart';
import 'package:pearl/data/repositories/home_repository_impl.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/repositories/asset_repository.dart';
import 'package:pearl/domain/repositories/asset_template_repository.dart';
import 'package:pearl/domain/repositories/home_repository.dart';
import 'package:pearl/domain/usecases/add_asset_use_case.dart';
import 'package:pearl/domain/usecases/search_asset_templates_use_case.dart';
import 'package:pearl/domain/usecases/delete_asset_use_case.dart';
import 'package:pearl/domain/usecases/delete_home_use_case.dart';
import 'package:pearl/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/domain/usecases/get_homes_use_case.dart';
import 'package:pearl/domain/usecases/create_home_use_case.dart';
import 'package:pearl/domain/usecases/update_asset_use_case.dart';
import 'package:pearl/domain/usecases/update_home_use_case.dart';
import 'package:pearl/presentation/views/asset_form/asset_form_controller.dart';
import 'package:pearl/presentation/views/home_detail/home_detail_controller.dart';
import 'package:pearl/presentation/views/home_form/home_form_controller.dart';
import 'package:pearl/presentation/views/homes_list/homes_list_controller.dart';

import 'dependency_injector.dart';
import 'package:pearl/infra/di/get_it_dependency_injector.dart';

final DependencyInjector injector = GetItDependencyInjector();

Future<void> setupServiceLocator() async {
  final homeBox = await Hive.openBox<HomeHiveDto>('homes');
  final assetBox = await Hive.openBox<AssetHiveDto>('assets');

  injector.registerSingleton<Box<HomeHiveDto>>(homeBox);
  injector.registerSingleton<Box<AssetHiveDto>>(assetBox);

  // Repositories
  injector.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(
      injector.get<Box<HomeHiveDto>>(),
      injector.get<Box<AssetHiveDto>>(),
    ),
  );
  injector.registerLazySingleton<AssetRepository>(
    () => AssetRepositoryImpl(injector.get<Box<AssetHiveDto>>()),
  );
  injector.registerLazySingleton<AssetTemplateRepository>(
    () => AssetTemplateRepositoryImpl(),
  );

  // Home usecases
  injector.registerLazySingleton(
    () => GetHomesUseCase(injector.get<HomeRepository>()),
  );
  injector.registerLazySingleton(
    () => GetHomeByIdUseCase(injector.get<HomeRepository>()),
  );
  injector.registerLazySingleton(
    () => CreateHomeUseCase(injector.get<HomeRepository>()),
  );
  injector.registerLazySingleton(
    () => UpdateHomeUseCase(injector.get<HomeRepository>()),
  );
  injector.registerLazySingleton(
    () => DeleteHomeUseCase(injector.get<HomeRepository>()),
  );

  // Asset usecases
  injector.registerLazySingleton(
    () => AddAssetUseCase(injector.get<AssetRepository>()),
  );
  injector.registerLazySingleton(
    () => UpdateAssetUseCase(injector.get<AssetRepository>()),
  );
  injector.registerLazySingleton(
    () => DeleteAssetUseCase(injector.get<AssetRepository>()),
  );
  injector.registerLazySingleton(
    () => SearchAssetTemplatesUseCase(
      injector.get<AssetTemplateRepository>(),
    ),
  );

  // Subject Notifier
  injector.registerLazySingleton<SubjectNotifier>(() => SubjectNotifier());

  // Controllers
  injector.registerFactory(
    () => HomesListController(
      injector.get<GetHomesUseCase>(),
      injector.get<DeleteHomeUseCase>(),
      injector.get<SubjectNotifier>(),
    ),
  );
  injector.registerFactoryParam<HomeFormController, HomeModel?, void>(
    (home, _) => HomeFormController(
      injector.get<CreateHomeUseCase>(),
      injector.get<UpdateHomeUseCase>(),
      home: home,
    ),
  );
  injector.registerFactoryParam<HomeDetailController, String, void>(
    (homeId, _) => HomeDetailController(
      injector.get<GetHomeByIdUseCase>(),
      injector.get<DeleteAssetUseCase>(),
      injector.get<SubjectNotifier>(),
      homeId,
    ),
  );
  injector.registerFactoryParam<AssetFormController, String, AssetModel?>(
    (homeId, asset) => AssetFormController(
      injector.get<AddAssetUseCase>(),
      injector.get<UpdateAssetUseCase>(),
      injector.get<SearchAssetTemplatesUseCase>(),
      homeId,
      asset: asset,
    ),
  );
}
