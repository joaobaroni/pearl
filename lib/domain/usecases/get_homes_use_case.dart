import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/repositories/home_repository.dart';

class GetHomesUseCase {
  final HomeRepository _repository;
  GetHomesUseCase(this._repository);

  Either<Failure, List<HomeModel>> call() => _repository.getAll();
}
