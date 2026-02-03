import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../models/asset_template.dart';
import '../repositories/asset_template_repository.dart';

class SearchAssetTemplatesUseCase {
  final AssetTemplateRepository _repository;

  SearchAssetTemplatesUseCase(this._repository);

  Future<Either<Failure, List<AssetTemplate>>> call(String query) =>
      _repository.search(query);
}
