import 'package:pearl/features/homes/data/dtos/asset_hive_dto.dart';
import 'package:pearl/features/homes/domain/models/asset_model.dart';
import 'package:pearl/features/homes/domain/models/asset_category.dart';

extension AssetHiveDtoMapper on AssetHiveDto {
  AssetModel toModel() => AssetModel(
        id: id,
        name: name,
        category: AssetCategory.values[categoryIndex],
        manufacturer: manufacturer,
        model: model,
        installDate: installDate,
        warrantyDate: warrantyDate,
        notes: notes,
      );
}

extension AssetToHiveDto on AssetModel {
  AssetHiveDto toHiveDto({required String homeId}) => AssetHiveDto(
        id: id,
        name: name,
        categoryIndex: category.index,
        manufacturer: manufacturer,
        model: model,
        installDate: installDate,
        warrantyDate: warrantyDate,
        notes: notes,
        homeId: homeId,
      );
}
