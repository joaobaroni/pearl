import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/data/dtos/address_hive_dto.dart';
import 'package:pearl/data/dtos/home_hive_dto.dart';
import 'package:pearl/data/mappers/home_mapper.dart';
import 'package:pearl/domain/models/address_model.dart';
import 'package:pearl/domain/models/asset_model.dart';
import 'package:pearl/domain/models/asset_category.dart';
import 'package:pearl/domain/models/home_model.dart';
import 'package:pearl/domain/models/us_state.dart';

void main() {
  group('HomeHiveDtoMapper.toModel', () {
    test('maps all fields correctly with default empty assets', () {
      final createdAt = DateTime(2024, 3, 10);

      final dto = HomeHiveDto(
        id: 'home-1',
        name: 'My House',
        address: AddressHiveDto(
          street: '123 Main St',
          city: 'Los Angeles',
          state: 'CA',
          zip: '90001',
        ),
        createdAt: createdAt,
      );

      final model = dto.toModel();

      expect(model.id, 'home-1');
      expect(model.name, 'My House');
      expect(model.address.street, '123 Main St');
      expect(model.address.city, 'Los Angeles');
      expect(model.address.state, UsState.ca);
      expect(model.address.zip, '90001');
      expect(model.assets, isEmpty);
      expect(model.createdAt, createdAt);
    });

    test('maps with provided assets list', () {
      final dto = HomeHiveDto(
        id: 'home-1',
        name: 'My House',
        address: AddressHiveDto(
          street: '123 Main St',
          city: 'LA',
          state: 'CA',
          zip: '90001',
        ),
        createdAt: DateTime(2024, 3, 10),
      );

      final assets = [
        const AssetModel(
          id: 'asset-1',
          name: 'AC Unit',
          category: AssetCategory.hvac,
        ),
        const AssetModel(
          id: 'asset-2',
          name: 'Solar Panel',
          category: AssetCategory.solar,
        ),
      ];

      final model = dto.toModel(assets: assets);

      expect(model.assets.length, 2);
      expect(model.assets[0].id, 'asset-1');
      expect(model.assets[1].id, 'asset-2');
    });

    test('maps nested address correctly', () {
      final dto = HomeHiveDto(
        id: 'home-1',
        name: 'Beach House',
        address: AddressHiveDto(
          street: '456 Ocean Dr',
          city: 'Miami',
          state: 'FL',
          zip: '33101',
        ),
        createdAt: DateTime(2024, 1, 1),
      );

      final model = dto.toModel();

      expect(model.address.state, UsState.fl);
      expect(model.address.city, 'Miami');
    });
  });

  group('HomeToHiveDto.toHiveDto', () {
    test('maps all fields correctly', () {
      final createdAt = DateTime(2024, 3, 10);

      final model = HomeModel(
        id: 'home-1',
        name: 'My House',
        address: const AddressModel(
          street: '123 Main St',
          city: 'Los Angeles',
          state: UsState.ca,
          zip: '90001',
        ),
        createdAt: createdAt,
      );

      final dto = model.toHiveDto();

      expect(dto.id, 'home-1');
      expect(dto.name, 'My House');
      expect(dto.address.street, '123 Main St');
      expect(dto.address.city, 'Los Angeles');
      expect(dto.address.state, 'CA');
      expect(dto.address.zip, '90001');
      expect(dto.createdAt, createdAt);
    });

    test('does not include assets in dto', () {
      final model = HomeModel(
        id: 'home-1',
        name: 'My House',
        address: const AddressModel(
          street: '123 Main St',
          city: 'LA',
          state: UsState.ca,
          zip: '90001',
        ),
        assets: const [
          AssetModel(
            id: 'asset-1',
            name: 'AC Unit',
            category: AssetCategory.hvac,
          ),
        ],
        createdAt: DateTime(2024, 3, 10),
      );

      final dto = model.toHiveDto();

      // HomeHiveDto does not have an assets field
      expect(dto.id, model.id);
      expect(dto.name, model.name);
    });
  });

  group('HomeMapper round-trip', () {
    test('toHiveDto then toModel preserves data (except assets)', () {
      final original = HomeModel(
        id: 'home-1',
        name: 'Mountain Cabin',
        address: const AddressModel(
          street: '789 Pine Rd',
          city: 'Denver',
          state: UsState.co,
          zip: '80201',
        ),
        createdAt: DateTime(2024, 5, 20),
      );

      final result = original.toHiveDto().toModel();

      expect(result.id, original.id);
      expect(result.name, original.name);
      expect(result.address.street, original.address.street);
      expect(result.address.city, original.address.city);
      expect(result.address.state, original.address.state);
      expect(result.address.zip, original.address.zip);
      expect(result.createdAt, original.createdAt);
      expect(result.assets, isEmpty);
    });
  });
}
