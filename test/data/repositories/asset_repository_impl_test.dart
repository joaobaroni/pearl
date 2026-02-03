import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/repositories/asset_repository_impl.dart';
import 'package:pearl/domain/models/asset_category.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/hive_test_helper.dart';

void main() {
  late Directory tempDir;
  late Box<AssetHiveDto> assetBox;
  late AssetRepositoryImpl repository;

  setUp(() async {
    tempDir = await initHiveForTest();
    assetBox = await Hive.openBox<AssetHiveDto>('assets');
    repository = AssetRepositoryImpl(assetBox);
  });

  tearDown(() async {
    await tearDownHive(tempDir);
  });

  group('AssetRepositoryImpl', () {
    group('add', () {
      test('adds asset and returns AssetModel', () async {
        final params = fakeSaveAssetParams(name: 'Water Heater');
        final result = await repository.add('home1', params);

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (asset) {
            expect(asset.name, 'Water Heater');
            expect(asset.category, AssetCategory.hvac);
            expect(assetBox.length, 1);
          },
        );
      });
    });

    group('update', () {
      test('updates existing asset and returns updated model', () async {
        final dto = fakeAssetDto(id: 'a1', name: 'Old Name', homeId: 'home1');
        await assetBox.put('a1', dto);

        final params = fakeSaveAssetParams(name: 'New Name');
        final result = await repository.update('home1', 'a1', params);

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (asset) => expect(asset.name, 'New Name'),
        );
      });

      test('returns NotFoundFailure when asset does not exist', () async {
        final params = fakeSaveAssetParams();
        final result = await repository.update('home1', 'nonexistent', params);

        result.fold(
          (failure) => expect(failure, isA<NotFoundFailure>()),
          (_) => fail('Expected Left, got Right'),
        );
      });
    });

    group('delete', () {
      test('removes asset from box', () async {
        final dto = fakeAssetDto(id: 'a1', homeId: 'home1');
        await assetBox.put('a1', dto);

        final result = await repository.delete('home1', 'a1');

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (_) => expect(assetBox.containsKey('a1'), isFalse),
        );
      });
    });
  });
}
