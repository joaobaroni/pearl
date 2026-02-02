import 'package:hive/hive.dart';

part 'asset_hive_dto.g.dart';

@HiveType(typeId: 2)
class AssetHiveDto {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final int categoryIndex;

  @HiveField(3)
  final String manufacturer;

  @HiveField(4)
  final String model;

  @HiveField(5)
  final DateTime? installDate;

  @HiveField(6)
  final DateTime? warrantyDate;

  @HiveField(7)
  final String notes;

  AssetHiveDto({
    required this.id,
    required this.name,
    required this.categoryIndex,
    required this.manufacturer,
    required this.model,
    this.installDate,
    this.warrantyDate,
    required this.notes,
  });
}
