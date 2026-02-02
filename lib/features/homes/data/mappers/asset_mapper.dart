import 'package:pearl/features/homes/data/dtos/asset_hive_dto.dart';
import 'package:pearl/features/homes/domain/models/asset.dart';
import 'package:pearl/features/homes/domain/models/asset_category.dart';

extension AssetHiveDtoMapper on AssetHiveDto {
  Asset toDomain() => Asset(
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

extension AssetToHiveDto on Asset {
  AssetHiveDto toHiveDto() => AssetHiveDto(
        id: id,
        name: name,
        categoryIndex: category.index,
        manufacturer: manufacturer,
        model: model,
        installDate: installDate,
        warrantyDate: warrantyDate,
        notes: notes,
      );
}
