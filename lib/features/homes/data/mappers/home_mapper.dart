import 'package:pearl/features/homes/data/dtos/home_hive_dto.dart';
import 'package:pearl/features/homes/data/mappers/address_mapper.dart';
import 'package:pearl/features/homes/data/mappers/asset_mapper.dart';
import 'package:pearl/features/homes/domain/models/home.dart';

extension HomeHiveDtoMapper on HomeHiveDto {
  Home toDomain() => Home(
        id: id,
        name: name,
        address: address.toDomain(),
        assets: assets.map((dto) => dto.toDomain()).toList(),
        createdAt: createdAt,
      );
}

extension HomeToHiveDto on Home {
  HomeHiveDto toHiveDto() => HomeHiveDto(
        id: id,
        name: name,
        address: address.toHiveDto(),
        assets: assets.map((asset) => asset.toHiveDto()).toList(),
        createdAt: createdAt,
      );
}
