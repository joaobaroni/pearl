import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/get_homes_use_case.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockHomeRepository mockRepository;
  late GetHomesUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetHomesUseCase(mockRepository);
  });

  group('GetHomesUseCase', () {
    test('returns list of homes on success', () {
      final homes = [fakeHome(id: '1'), fakeHome(id: '2')];
      when(() => mockRepository.getAll()).thenReturn(Right(homes));

      final result = useCase();

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, 2),
      );
      verify(() => mockRepository.getAll()).called(1);
    });

    test('returns failure on error', () {
      when(() => mockRepository.getAll())
          .thenReturn(const Left(StorageFailure('error')));

      final result = useCase();

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
