import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/features/homes/domain/models/home.dart';
import 'package:pearl/features/homes/domain/usecases/params/save_home_params.dart';

abstract class HomeRepository {
  Either<Failure, List<Home>> getAll();
  Either<Failure, Home> getById(String id);
  Future<Either<Failure, void>> create(SaveHomeParams params);
  Future<Either<Failure, void>> update(String id, SaveHomeParams params);
  Future<Either<Failure, void>> delete(String id);
}
