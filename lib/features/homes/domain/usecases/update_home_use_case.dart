import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_home_params.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class UpdateHomeUseCase {
  final HomeRepository _repository;
  UpdateHomeUseCase(this._repository);

  Future<Either<Failure, void>> call(String id, SaveHomeParams params) =>
      _repository.update(id, params);
}
