import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/repositories/asset_repository.dart';

class DeleteAssetUseCase {
  final AssetRepository _repository;
  DeleteAssetUseCase(this._repository);

  Future<Either<Failure, void>> call(String homeId, String assetId) =>
      _repository.delete(homeId, assetId);
}
