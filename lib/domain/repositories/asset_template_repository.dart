import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../models/asset_template.dart';

abstract class AssetTemplateRepository {
  Future<Either<Failure, List<AssetTemplate>>> search(String query);
}
