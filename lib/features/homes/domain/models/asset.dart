import 'asset_category.dart';

class Asset {
  final String id;
  final String name;
  final AssetCategory category;
  final String manufacturer;
  final String model;
  final DateTime? installDate;
  final DateTime? warrantyDate;
  final String notes;

  const Asset({
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
