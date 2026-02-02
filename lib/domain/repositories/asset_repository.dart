import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/asset_model.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_asset_params.dart';

abstract class AssetRepository {
  Future<Either<Failure, AssetModel>> add(String homeId, SaveAssetParams params);
  Future<Either<Failure, AssetModel>> update(
    String homeId,
    String assetId,
    SaveAssetParams params,
  );
  Future<Either<Failure, void>> delete(String homeId, String assetId);
}
