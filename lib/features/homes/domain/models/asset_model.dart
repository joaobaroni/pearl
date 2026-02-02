import 'asset_category.dart';

class AssetModel {
  final String id;
  final String name;
  final AssetCategory category;
  final String manufacturer;
  final String model;
  final DateTime? installDate;
  final DateTime? warrantyDate;
  final String notes;

  const AssetModel({
    required this.id,
    required this.name,
    required this.category,
    this.manufacturer = '',
    this.model = '',
    this.installDate,
    this.warrantyDate,
    this.notes = '',
  });
}
