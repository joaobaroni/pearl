import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/data/dtos/address_hive_dto.dart';
import 'package:pearl/data/mappers/address_mapper.dart';
import 'package:pearl/domain/models/address_model.dart';
import 'package:pearl/domain/models/us_state.dart';

void main() {
  group('AddressHiveDtoMapper.toModel', () {
    test('maps all fields correctly', () {
      final dto = AddressHiveDto(
        street: '123 Main St',
        city: 'Los Angeles',
        state: 'CA',
        zip: '90001',
      );

      final model = dto.toModel();

      expect(model.street, '123 Main St');
      expect(model.city, 'Los Angeles');
      expect(model.state, UsState.ca);
      expect(model.zip, '90001');
    });

    test('maps state abbreviation to correct UsState enum', () {
      final dto = AddressHiveDto(
        street: '456 Elm St',
        city: 'New York',
        state: 'NY',
        zip: '10001',
      );

      final model = dto.toModel();

      expect(model.state, UsState.ny);
    });

    test('defaults to CA for unknown state abbreviation', () {
      final dto = AddressHiveDto(
        street: '789 Oak St',
        city: 'Unknown',
        state: 'XX',
        zip: '00000',
      );

      final model = dto.toModel();

      expect(model.state, UsState.ca);
    });
  });

  group('AddressToHiveDto.toHiveDto', () {
    test('maps all fields correctly', () {
      const model = AddressModel(
        street: '123 Main St',
        city: 'Los Angeles',
        state: UsState.ca,
        zip: '90001',
      );

      final dto = model.toHiveDto();

      expect(dto.street, '123 Main St');
      expect(dto.city, 'Los Angeles');
      expect(dto.state, 'CA');
      expect(dto.zip, '90001');
    });

    test('converts UsState enum to abbreviation string', () {
      const model = AddressModel(
        street: '456 Elm St',
        city: 'New York',
        state: UsState.ny,
        zip: '10001',
      );

      final dto = model.toHiveDto();

      expect(dto.state, 'NY');
    });
  });

  group('AddressMapper round-trip', () {
    test('toHiveDto then toModel preserves data', () {
      const original = AddressModel(
        street: '100 Broadway',
        city: 'Austin',
        state: UsState.tx,
        zip: '73301',
      );

      final result = original.toHiveDto().toModel();

      expect(result.street, original.street);
      expect(result.city, original.city);
      expect(result.state, original.state);
      expect(result.zip, original.zip);
    });
  });
}
