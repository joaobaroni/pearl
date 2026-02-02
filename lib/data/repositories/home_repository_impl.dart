import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/data/dtos/asset_hive_dto.dart';
import 'package:pearl/features/homes/data/dtos/home_hive_dto.dart';
import 'package:pearl/features/homes/data/mappers/address_mapper.dart';
import 'package:pearl/features/homes/data/mappers/asset_mapper.dart';
import 'package:pearl/features/homes/data/mappers/home_mapper.dart';
import 'package:pearl/features/homes/domain/models/asset_model.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_home_params.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Box<HomeHiveDto> _homeBox;
  final Box<AssetHiveDto> _assetBox;

  HomeRepositoryImpl(this._homeBox, this._assetBox);

  List<HomeHiveDto> _getAllDtos() => _homeBox.values.toList();

  HomeHiveDto? _getDtoById(String id) => _homeBox.get(id);

  Future<void> _upsert(HomeHiveDto dto) => _homeBox.put(dto.id, dto);

  Future<void> _remove(String id) => _homeBox.delete(id);

  List<AssetModel> _getAssetsForHome(String homeId) => _assetBox.values
      .where((dto) => dto.homeId == homeId)
      .map((dto) => dto.toModel())
      .toList();

  @override
  Either<Failure, List<HomeModel>> getAll() {
    try {
      return Right(
        _getAllDtos()
            .map((dto) => dto.toModel(assets: _getAssetsForHome(dto.id)))
            .toList(),
      );
    } catch (e) {
      return Left(StorageFailure('Failed to load homes: $e'));
    }
  }

  @override
  Either<Failure, HomeModel> getById(String id) {
    try {
      final dto = _getDtoById(id);
      if (dto == null) {
        return Left(NotFoundFailure('Home not found: $id'));
      }
      final assets = _getAssetsForHome(id);
      return Right(dto.toModel(assets: assets));
    } catch (e) {
      return Left(StorageFailure('Failed to load home: $e'));
    }
  }

  @override
  Future<Either<Failure, HomeModel>> create(SaveHomeParams params) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final dto = HomeHiveDto(
        id: id,
        name: params.name,
        address: params.address.toHiveDto(),
        createdAt: DateTime.now(),
      );
      await _upsert(dto);
      return Right(dto.toModel(assets: []));
    } catch (e) {
      return Left(StorageFailure('Failed to create home: $e'));
    }
  }

  @override
  Future<Either<Failure, HomeModel>> update(String id, SaveHomeParams params) async {
    try {
      final existing = _getDtoById(id);
      if (existing == null) {
        return Left(NotFoundFailure('Home not found: $id'));
      }
      final dto = HomeHiveDto(
        id: existing.id,
        name: params.name,
        address: params.address.toHiveDto(),
        createdAt: existing.createdAt,
      );
      await _upsert(dto);
      final assets = _getAssetsForHome(id);
      return Right(dto.toModel(assets: assets));
    } catch (e) {
      return Left(StorageFailure('Failed to update home: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> delete(String id) async {
    try {
      await _remove(id);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure('Failed to delete home: $e'));
    }
  }
}
