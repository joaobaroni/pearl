import 'package:dartz/dartz.dart';

import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/usecases/params/save_home_params.dart';

abstract class HomeRepository {
  Either<Failure, List<HomeModel>> getAll();
  Either<Failure, HomeModel> getById(String id);
  Future<Either<Failure, HomeModel>> create(SaveHomeParams params);
  Future<Either<Failure, HomeModel>> update(String id, SaveHomeParams params);
  Future<Either<Failure, void>> delete(String id);
}
