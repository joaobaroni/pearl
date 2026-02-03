import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/mappers/asset_mapper.dart';
import 'package:pearl/domain/models/asset_category.dart';
import 'package:pearl/domain/models/asset_model.dart';

void main() {
  group('AssetHiveDtoMapper.toModel', () {
    test('maps all fields correctly', () {
      final installDate = DateTime(2024, 1, 15);
      final warrantyDate = DateTime(2026, 1, 15);

      final dto = AssetHiveDto(
        id: 'asset-1',
        name: 'Air Conditioner',
        categoryIndex: AssetCategory.hvac.index,
        manufacturer: 'Carrier',
        model: 'Infinity 24',
        installDate: installDate,
        warrantyDate: warrantyDate,
        notes: 'Installed in living room',
        homeId: 'home-1',
      );

      final model = dto.toModel();

      expect(model.id, 'asset-1');
      expect(model.name, 'Air Conditioner');
      expect(model.category, AssetCategory.hvac);
      expect(model.manufacturer, 'Carrier');
      expect(model.model, 'Infinity 24');
      expect(model.installDate, installDate);
      expect(model.warrantyDate, warrantyDate);
      expect(model.notes, 'Installed in living room');
    });

    test('maps null dates correctly', () {
      final dto = AssetHiveDto(
        id: 'asset-2',
        name: 'Water Heater',
        categoryIndex: AssetCategory.plumbing.index,
        manufacturer: 'Rheem',
        model: 'Performance Plus',
        notes: '',
        homeId: 'home-1',
      );

      final model = dto.toModel();

      expect(model.installDate, isNull);
      expect(model.warrantyDate, isNull);
    });

    test('maps each category index correctly', () {
      for (final category in AssetCategory.values) {
        final dto = AssetHiveDto(
          id: 'asset-${category.index}',
          name: 'Test',
          categoryIndex: category.index,
          manufacturer: '',
          model: '',
          notes: '',
          homeId: 'home-1',
        );

        expect(dto.toModel().category, category);
      }
    });
  });

  group('AssetToHiveDto.toHiveDto', () {
    test('maps all fields correctly', () {
      final installDate = DateTime(2024, 1, 15);
      final warrantyDate = DateTime(2026, 1, 15);

      const model = AssetModel(
        id: 'asset-1',
        name: 'Air Conditioner',
        category: AssetCategory.hvac,
        manufacturer: 'Carrier',
        model: 'Infinity 24',
        notes: 'Installed in living room',
      );

      final dto = AssetModel(
        id: model.id,
        name: model.name,
        category: model.category,
        manufacturer: model.manufacturer,
        model: model.model,
        installDate: installDate,
        warrantyDate: warrantyDate,
        notes: model.notes,
      ).toHiveDto(homeId: 'home-1');

      expect(dto.id, 'asset-1');
      expect(dto.name, 'Air Conditioner');
      expect(dto.categoryIndex, AssetCategory.hvac.index);
      expect(dto.manufacturer, 'Carrier');
      expect(dto.model, 'Infinity 24');
      expect(dto.installDate, installDate);
      expect(dto.warrantyDate, warrantyDate);
      expect(dto.notes, 'Installed in living room');
      expect(dto.homeId, 'home-1');
    });

    test('includes homeId parameter in dto', () {
      const model = AssetModel(
        id: 'asset-1',
        name: 'Test',
        category: AssetCategory.solar,
      );

      final dto = model.toHiveDto(homeId: 'home-42');

      expect(dto.homeId, 'home-42');
    });
  });

  group('AssetMapper round-trip', () {
    test('toHiveDto then toModel preserves data', () {
      final model = AssetModel(
        id: 'asset-1',
        name: 'Solar Panel',
        category: AssetCategory.solar,
        manufacturer: 'SunPower',
        model: 'Maxeon 6',
        installDate: DateTime(2024, 6, 1),
        warrantyDate: DateTime(2049, 6, 1),
        notes: 'Roof installation',
      );

      final result = model.toHiveDto(homeId: 'home-1').toModel();

      expect(result.id, model.id);
      expect(result.name, model.name);
      expect(result.category, model.category);
      expect(result.manufacturer, model.manufacturer);
      expect(result.model, model.model);
      expect(result.installDate, model.installDate);
      expect(result.warrantyDate, model.warrantyDate);
      expect(result.notes, model.notes);
    });
  });
}
