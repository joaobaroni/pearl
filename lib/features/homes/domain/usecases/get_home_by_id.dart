import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/home.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class GetHomeById {
  final HomeRepository _repository;
  GetHomeById(this._repository);

  Either<Failure, Home> call(String id) => _repository.getById(id);
}
