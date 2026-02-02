import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/home_model.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class GetHomeByIdUseCase {
  final HomeRepository _repository;
  GetHomeByIdUseCase(this._repository);

  Either<Failure, HomeModel> call(String id) => _repository.getById(id);
}
