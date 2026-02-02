import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/usecases/params/save_home_params.dart';
import 'package:pearl/domain/repositories/home_repository.dart';

class CreateHomeUseCase {
  final HomeRepository _repository;
  CreateHomeUseCase(this._repository);

  Future<Either<Failure, HomeModel>> call(SaveHomeParams params) =>
      _repository.create(params);
}
