import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/repositories/asset_repository.dart';
import 'package:pearl/domain/usecases/params/save_asset_params.dart';

class AddAssetUseCase {
  final AssetRepository _repository;
  AddAssetUseCase(this._repository);

  Future<Either<Failure, AssetModel>> call(String homeId, SaveAssetParams params) =>
      _repository.add(homeId, params);
}
