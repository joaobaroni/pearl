import 'package:hive/hive.dart';

import 'address_hive_dto.dart';

part 'home_hive_dto.g.dart';

@HiveType(typeId: 0)
class HomeHiveDto extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final AddressHiveDto address;

  @HiveField(4)
  final DateTime createdAt;

  HomeHiveDto({
    required this.id,
    required this.name,
    required this.address,
    required this.createdAt,
  });
}
