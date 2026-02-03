import 'package:pearl/data/dtos/address_hive_dto.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/dtos/home_hive_dto.dart';
import 'package:pearl/domain/models/address_model.dart';
import 'package:pearl/domain/models/asset_category.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/models/us_state.dart';
import 'package:pearl/domain/usecases/params/save_asset_params.dart';
import 'package:pearl/domain/usecases/params/save_home_params.dart';

// Domain models

AddressModel fakeAddress({
  String street = '123 Main St',
  String city = 'San Francisco',
  UsState state = UsState.ca,
  String zip = '94105',
}) =>
    AddressModel(street: street, city: city, state: state, zip: zip);

HomeModel fakeHome({
  String id = '1',
  String name = 'My House',
  AddressModel? address,
  List<AssetModel> assets = const [],
  DateTime? createdAt,
}) =>
    HomeModel(
      id: id,
      name: name,
      address: address ?? fakeAddress(),
      assets: assets,
      createdAt: createdAt ?? DateTime(2025, 1, 1),
    );

AssetModel fakeAsset({
  String id = 'a1',
  String name = 'Air Conditioner',
  AssetCategory category = AssetCategory.hvac,
  String manufacturer = 'Carrier',
  String model = 'Model X',
  DateTime? installDate,
  DateTime? warrantyDate,
  String notes = '',
}) =>
    AssetModel(
      id: id,
      name: name,
      category: category,
      manufacturer: manufacturer,
      model: model,
      installDate: installDate,
      warrantyDate: warrantyDate,
      notes: notes,
    );

// Params

SaveHomeParams fakeSaveHomeParams({
  String name = 'My House',
  AddressModel? address,
}) =>
    SaveHomeParams(name: name, address: address ?? fakeAddress());

SaveAssetParams fakeSaveAssetParams({
  String name = 'Air Conditioner',
  AssetCategory category = AssetCategory.hvac,
  String manufacturer = 'Carrier',
  String model = 'Model X',
  DateTime? installDate,
  DateTime? warrantyDate,
  String notes = '',
}) =>
    SaveAssetParams(
      name: name,
      category: category,
      manufacturer: manufacturer,
      model: model,
      installDate: installDate,
      warrantyDate: warrantyDate,
      notes: notes,
    );

// Hive DTOs

AddressHiveDto fakeAddressDto({
  String street = '123 Main St',
  String city = 'San Francisco',
  String state = 'CA',
  String zip = '94105',
}) =>
    AddressHiveDto(street: street, city: city, state: state, zip: zip);

HomeHiveDto fakeHomeDto({
  String id = '1',
  String name = 'My House',
  AddressHiveDto? address,
  DateTime? createdAt,
}) =>
    HomeHiveDto(
      id: id,
      name: name,
      address: address ?? fakeAddressDto(),
      createdAt: createdAt ?? DateTime(2025, 1, 1),
    );

AssetHiveDto fakeAssetDto({
  String id = 'a1',
  String name = 'Air Conditioner',
  int categoryIndex = 0,
  String manufacturer = 'Carrier',
  String model = 'Model X',
  String notes = '',
  String homeId = '1',
}) =>
    AssetHiveDto(
      id: id,
      name: name,
      categoryIndex: categoryIndex,
      manufacturer: manufacturer,
      model: model,
      notes: notes,
      homeId: homeId,
    );
