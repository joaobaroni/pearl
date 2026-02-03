import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/delete_home_use_case.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockHomeRepository mockRepository;
  late DeleteHomeUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = DeleteHomeUseCase(mockRepository);
  });

  group('DeleteHomeUseCase', () {
    test('returns Right(null) on success', () async {
      when(() => mockRepository.delete(any()))
          .thenAnswer((_) async => const Right(null));

      final result = await useCase('1');

      result.fold(
        (failure) => fail('Expected Right'),
        (_) {},
      );
      verify(() => mockRepository.delete('1')).called(1);
    });

    test('returns failure on error', () async {
      when(() => mockRepository.delete(any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final result = await useCase('1');

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
