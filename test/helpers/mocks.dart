import 'package:hive/hive.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/controllers/subject_notifier.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/dtos/home_hive_dto.dart';
import 'package:pearl/domain/repositories/asset_repository.dart';
import 'package:pearl/domain/repositories/asset_template_repository.dart';
import 'package:pearl/domain/repositories/home_repository.dart';
import 'package:pearl/domain/usecases/add_asset_use_case.dart';
import 'package:pearl/domain/usecases/create_home_use_case.dart';
import 'package:pearl/domain/usecases/delete_asset_use_case.dart';
import 'package:pearl/domain/usecases/delete_home_use_case.dart';
import 'package:pearl/domain/usecases/get_home_by_id_use_case.dart';
import 'package:pearl/domain/usecases/get_homes_use_case.dart';
import 'package:pearl/domain/usecases/search_asset_templates_use_case.dart';
import 'package:pearl/domain/usecases/update_asset_use_case.dart';
import 'package:pearl/domain/usecases/update_home_use_case.dart';

// Hive boxes
class MockHomeBox extends Mock implements Box<HomeHiveDto> {}

class MockAssetBox extends Mock implements Box<AssetHiveDto> {}

// Repositories
class MockHomeRepository extends Mock implements HomeRepository {}

class MockAssetRepository extends Mock implements AssetRepository {}

class MockAssetTemplateRepository extends Mock
    implements AssetTemplateRepository {}

// Use Cases
class MockGetHomesUseCase extends Mock implements GetHomesUseCase {}

class MockGetHomeByIdUseCase extends Mock implements GetHomeByIdUseCase {}

class MockCreateHomeUseCase extends Mock implements CreateHomeUseCase {}

class MockUpdateHomeUseCase extends Mock implements UpdateHomeUseCase {}

class MockDeleteHomeUseCase extends Mock implements DeleteHomeUseCase {}

class MockAddAssetUseCase extends Mock implements AddAssetUseCase {}

class MockUpdateAssetUseCase extends Mock implements UpdateAssetUseCase {}

class MockDeleteAssetUseCase extends Mock implements DeleteAssetUseCase {}

class MockSearchAssetTemplatesUseCase extends Mock
    implements SearchAssetTemplatesUseCase {}

// Subject Notifier
class MockSubjectNotifier extends Mock implements SubjectNotifier {}
