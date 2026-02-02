import 'package:pearl/features/homes/data/dtos/address_hive_dto.dart';
import 'package:pearl/features/homes/domain/models/address.dart';
import 'package:pearl/features/homes/domain/models/us_state.dart';

extension AddressHiveDtoMapper on AddressHiveDto {
  Address toDomain() => Address(
        street: street,
        city: city,
        state: UsState.fromAbbreviation(state),
        zip: zip,
      );
}

extension AddressToHiveDto on Address {
  AddressHiveDto toHiveDto() => AddressHiveDto(
        street: street,
        city: city,
        state: state.abbreviation,
        zip: zip,
      );
}
