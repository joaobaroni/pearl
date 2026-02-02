import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/repositories/asset_repository.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_asset_params.dart';

class AddAssetUseCase {
  final AssetRepository _repository;
  AddAssetUseCase(this._repository);

  Future<Either<Failure, void>> call(String homeId, SaveAssetParams params) =>
      _repository.add(homeId, params);
}
