import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/mappers/asset_mapper.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/repositories/asset_repository.dart';
import 'package:pearl/domain/usecases/params/save_asset_params.dart';

class AssetRepositoryImpl implements AssetRepository {
  final Box<AssetHiveDto> _box;
  AssetRepositoryImpl(this._box);

  @override
  Future<Either<Failure, AssetModel>> add(
    String homeId,
    SaveAssetParams params,
  ) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final dto = AssetHiveDto(
        id: id,
        name: params.name,
        categoryIndex: params.category.index,
        manufacturer: params.manufacturer,
        model: params.model,
        installDate: params.installDate,
        warrantyDate: params.warrantyDate,
        notes: params.notes,
        homeId: homeId,
      );
      await _box.put(id, dto);
      return Right(dto.toModel());
    } catch (e) {
      return Left(StorageFailure('Failed to add asset: $e'));
    }
  }

  @override
  Future<Either<Failure, AssetModel>> update(
    String homeId,
    String assetId,
    SaveAssetParams params,
  ) async {
    try {
      final existing = _box.get(assetId);
      if (existing == null) {
        return Left(NotFoundFailure('Asset not found: $assetId'));
      }

      final dto = AssetHiveDto(
        id: assetId,
        name: params.name,
        categoryIndex: params.category.index,
        manufacturer: params.manufacturer,
        model: params.model,
        installDate: params.installDate,
        warrantyDate: params.warrantyDate,
        notes: params.notes,
        homeId: homeId,
      );
      await _box.put(assetId, dto);
      return Right(dto.toModel());
    } catch (e) {
      return Left(StorageFailure('Failed to update asset: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String homeId, String assetId) async {
    try {
      await _box.delete(assetId);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure('Failed to delete asset: $e'));
    }
  }
}
