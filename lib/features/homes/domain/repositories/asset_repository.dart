import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_asset_params.dart';

abstract class AssetRepository {
  Future<Either<Failure, void>> add(String homeId, SaveAssetParams params);
  Future<Either<Failure, void>> update(
    String homeId,
    String assetId,
    SaveAssetParams params,
  );
  Future<Either<Failure, void>> delete(String homeId, String assetId);
}
