import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/data/dtos/home_hive_dto.dart';
import 'package:pearl/features/homes/data/mappers/address_mapper.dart';
import 'package:pearl/features/homes/data/mappers/home_mapper.dart';
import 'package:pearl/features/homes/domain/models/home.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_home_params.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Box<HomeHiveDto> _box;
  HomeRepositoryImpl(this._box);

  List<HomeHiveDto> _getAllDtos() => _box.values.toList();

  HomeHiveDto? _getDtoById(String id) => _box.get(id);

  Future<void> _upsert(HomeHiveDto dto) => _box.put(dto.id, dto);

  Future<void> _remove(String id) => _box.delete(id);

  @override
  Either<Failure, List<Home>> getAll() {
    try {
      return Right(_getAllDtos().map((dto) => dto.toDomain()).toList());
    } catch (e) {
      return Left(StorageFailure('Failed to load homes: $e'));
    }
  }

  @override
  Either<Failure, Home> getById(String id) {
    try {
      final dto = _getDtoById(id);
      if (dto == null) {
        return Left(NotFoundFailure('Home not found: $id'));
      }
      return Right(dto.toDomain());
    } catch (e) {
      return Left(StorageFailure('Failed to load home: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> create(SaveHomeParams params) async {
    try {
      final dto = HomeHiveDto(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: params.name,
        address: params.address.toHiveDto(),
        assets: const [],
        createdAt: DateTime.now(),
      );
      await _upsert(dto);
      return const Right(null);
    } catch (e) {
      return Left(StorageFailure('Failed to create home: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> update(String id, SaveHomeParams params) async {
    try {
      final existing = _getDtoById(id);
      if (existing == null) {
        return Left(NotFoundFailure('Home not found: $id'));
      }
      final dto = HomeHiveDto(
        id: existing.id,
        name: params.name,
        address: params.address.toHiveDto(),
        assets: existing.assets,
        createdAt: existing.createdAt,
      );
      await _upsert(dto);
      return const Right(null);
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
