import 'package:hive/hive.dart';

part 'address_hive_dto.g.dart';

@HiveType(typeId: 1)
class AddressHiveDto {
  @HiveField(0)
  final String street;

  @HiveField(1)
  final String city;

  @HiveField(2)
  final String state;

  @HiveField(3)
  final String zip;

  AddressHiveDto({
    required this.street,
    required this.city,
    required this.state,
    required this.zip,
  });
}
