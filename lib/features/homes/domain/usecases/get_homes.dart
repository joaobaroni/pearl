import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/home.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class GetHomes {
  final HomeRepository _repository;
  GetHomes(this._repository);

  Either<Failure, List<Home>> call() => _repository.getAll();
}
