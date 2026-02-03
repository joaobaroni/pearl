import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/update_asset_use_case.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockAssetRepository mockRepository;
  late UpdateAssetUseCase useCase;

  setUpAll(() {
    registerFallbackValue(fakeSaveAssetParams());
  });

  setUp(() {
    mockRepository = MockAssetRepository();
    useCase = UpdateAssetUseCase(mockRepository);
  });

  group('UpdateAssetUseCase', () {
    test('returns updated asset on success', () async {
      final params = fakeSaveAssetParams(name: 'Updated');
      final asset = fakeAsset(id: 'a1', name: 'Updated');
      when(() => mockRepository.update(any(), any(), any()))
          .thenAnswer((_) async => Right(asset));

      final result = await useCase('home1', 'a1', params);

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.name, 'Updated'),
      );
      verify(() => mockRepository.update('home1', 'a1', params)).called(1);
    });

    test('returns failure when not found', () async {
      when(() => mockRepository.update(any(), any(), any()))
          .thenAnswer((_) async => const Left(NotFoundFailure('not found')));

      final result =
          await useCase('home1', 'nonexistent', fakeSaveAssetParams());

      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
