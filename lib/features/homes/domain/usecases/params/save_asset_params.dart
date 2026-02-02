import 'package:pearl/features/homes/domain/models/asset_category.dart';

class SaveAssetParams {
  final String name;
  final AssetCategory category;
  final String manufacturer;
  final String model;
  final DateTime? installDate;
  final DateTime? warrantyDate;
  final String notes;

  const SaveAssetParams({
    required this.name,
    required this.category,
    this.manufacturer = '',
    this.model = '',
    this.installDate,
    this.warrantyDate,
    this.notes = '',
  });
}
