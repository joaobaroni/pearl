import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/data/dtos/asset_hive_dto.dart';
import 'package:pearl/data/dtos/home_hive_dto.dart';
import 'package:pearl/data/repositories/home_repository_impl.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/hive_test_helper.dart';

void main() {
  late Directory tempDir;
  late Box<HomeHiveDto> homeBox;
  late Box<AssetHiveDto> assetBox;
  late HomeRepositoryImpl repository;

  setUp(() async {
    tempDir = await initHiveForTest();
    homeBox = await Hive.openBox<HomeHiveDto>('homes');
    assetBox = await Hive.openBox<AssetHiveDto>('assets');
    repository = HomeRepositoryImpl(homeBox, assetBox);
  });

  tearDown(() async {
    await tearDownHive(tempDir);
  });

  group('HomeRepositoryImpl', () {
    group('getAll', () {
      test('returns empty list when no homes exist', () {
        final result = repository.getAll();

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (homes) => expect(homes, isEmpty),
        );
      });

      test('returns homes with their associated assets', () async {
        await homeBox.put('1', fakeHomeDto(id: '1', name: 'House A'));
        await homeBox.put('2', fakeHomeDto(id: '2', name: 'House B'));
        await assetBox.put('a1', fakeAssetDto(id: 'a1', homeId: '1'));
        await assetBox.put('a2', fakeAssetDto(id: 'a2', homeId: '1'));
        await assetBox.put('a3', fakeAssetDto(id: 'a3', homeId: '2'));

        final result = repository.getAll();

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (homes) {
            expect(homes.length, 2);
            final house1 = homes.firstWhere((h) => h.id == '1');
            final house2 = homes.firstWhere((h) => h.id == '2');
            expect(house1.assets.length, 2);
            expect(house2.assets.length, 1);
          },
        );
      });
    });

    group('getById', () {
      test('returns home with assets when found', () async {
        await homeBox.put('1', fakeHomeDto(id: '1', name: 'My Home'));
        await assetBox.put('a1', fakeAssetDto(id: 'a1', homeId: '1'));

        final result = repository.getById('1');

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (home) {
            expect(home.name, 'My Home');
            expect(home.assets.length, 1);
          },
        );
      });

      test('returns NotFoundFailure when id does not exist', () {
        final result = repository.getById('nonexistent');

        result.fold(
          (failure) => expect(failure, isA<NotFoundFailure>()),
          (_) => fail('Expected Left, got Right'),
        );
      });
    });

    group('create', () {
      test('creates and returns HomeModel with generated id', () async {
        final params = fakeSaveHomeParams(name: 'New Home');

        final result = await repository.create(params);

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (home) {
            expect(home.name, 'New Home');
            expect(home.id, isNotEmpty);
            expect(home.assets, isEmpty);
            expect(homeBox.length, 1);
          },
        );
      });
    });

    group('update', () {
      test('updates existing home and preserves createdAt', () async {
        final original = fakeHomeDto(
          id: '1',
          name: 'Old Name',
          createdAt: DateTime(2024, 6, 15),
        );
        await homeBox.put('1', original);

        final params = fakeSaveHomeParams(name: 'New Name');
        final result = await repository.update('1', params);

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (home) {
            expect(home.name, 'New Name');
            expect(home.createdAt, DateTime(2024, 6, 15));
          },
        );
      });

      test('returns NotFoundFailure for non-existent id', () async {
        final params = fakeSaveHomeParams();
        final result = await repository.update('nonexistent', params);

        result.fold(
          (failure) => expect(failure, isA<NotFoundFailure>()),
          (_) => fail('Expected Left, got Right'),
        );
      });
    });

    group('delete', () {
      test('removes home from box', () async {
        await homeBox.put('1', fakeHomeDto(id: '1'));

        final result = await repository.delete('1');

        result.fold(
          (failure) => fail('Expected Right, got Left: ${failure.message}'),
          (_) => expect(homeBox.containsKey('1'), isFalse),
        );
      });
    });
  });
}
