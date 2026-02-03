import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/delete_asset_use_case.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAssetRepository mockRepository;
  late DeleteAssetUseCase useCase;

  setUp(() {
    mockRepository = MockAssetRepository();
    useCase = DeleteAssetUseCase(mockRepository);
  });

  group('DeleteAssetUseCase', () {
    test('returns Right(null) on success', () async {
      when(() => mockRepository.delete(any(), any()))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase('home1', 'a1');

      result.fold(
        (failure) => fail('Expected Right'),
        (_) {},
      );
      verify(() => mockRepository.delete('home1', 'a1')).called(1);
    });

    test('returns failure on error', () async {
      when(() => mockRepository.delete(any(), any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final result = await useCase('home1', 'a1');

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
