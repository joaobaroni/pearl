import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_home_params.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class CreateHome {
  final HomeRepository _repository;
  CreateHome(this._repository);

  Future<Either<Failure, void>> call(SaveHomeParams params) =>
      _repository.create(params);
}
