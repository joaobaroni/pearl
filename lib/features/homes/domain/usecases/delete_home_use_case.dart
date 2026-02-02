import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/repositories/home_repository.dart';

class DeleteHomeUseCase {
  final HomeRepository _repository;
  DeleteHomeUseCase(this._repository);

  Future<Either<Failure, void>> call(String id) => _repository.delete(id);
}
