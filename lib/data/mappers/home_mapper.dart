import 'package:pearl/data/dtos/home_hive_dto.dart';
import 'package:pearl/data/mappers/address_mapper.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/models/home_model.dart';

extension HomeHiveDtoMapper on HomeHiveDto {
  HomeModel toModel({List<AssetModel> assets = const []}) => HomeModel(
        id: id,
        name: name,
        address: address.toModel(),
        assets: assets,
        createdAt: createdAt,
      );
}

extension HomeToHiveDto on HomeModel {
  HomeHiveDto toHiveDto() => HomeHiveDto(
        id: id,
        name: name,
        address: address.toHiveDto(),
        createdAt: createdAt,
      );
}
