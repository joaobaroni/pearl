import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/add_asset_use_case.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockAssetRepository mockRepository;
  late AddAssetUseCase useCase;

  setUpAll(() {
    registerFallbackValue(fakeSaveAssetParams());
  });

  setUp(() {
    mockRepository = MockAssetRepository();
    useCase = AddAssetUseCase(mockRepository);
  });

  group('AddAssetUseCase', () {
    test('returns added asset on success', () async {
      final params = fakeSaveAssetParams(name: 'Water Heater');
      final asset = fakeAsset(id: 'a1', name: 'Water Heater');
      when(() => mockRepository.add(any(), any()))
          .thenAnswer((_) async => Right(asset));

      final result = await useCase('home1', params);

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.name, 'Water Heater'),
      );
      verify(() => mockRepository.add('home1', params)).called(1);
    });

    test('returns failure on error', () async {
      when(() => mockRepository.add(any(), any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final result = await useCase('home1', fakeSaveAssetParams());

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
