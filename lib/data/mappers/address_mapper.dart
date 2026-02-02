import 'package:pearl/features/homes/data/dtos/address_hive_dto.dart';
import 'package:pearl/features/homes/domain/models/address_model.dart';
import 'package:pearl/features/homes/domain/models/us_state.dart';

extension AddressHiveDtoMapper on AddressHiveDto {
  AddressModel toModel() => AddressModel(
        street: street,
        city: city,
        state: UsState.fromAbbreviation(state),
        zip: zip,
      );
}

extension AddressToHiveDto on AddressModel {
  AddressHiveDto toHiveDto() => AddressHiveDto(
        street: street,
        city: city,
        state: state.abbreviation,
        zip: zip,
      );
}
