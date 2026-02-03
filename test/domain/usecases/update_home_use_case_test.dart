import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/update_home_use_case.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockHomeRepository mockRepository;
  late UpdateHomeUseCase useCase;

  setUpAll(() {
    registerFallbackValue(fakeSaveHomeParams());
  });

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = UpdateHomeUseCase(mockRepository);
  });

  group('UpdateHomeUseCase', () {
    test('returns updated home on success', () async {
      final params = fakeSaveHomeParams(name: 'Updated');
      final home = fakeHome(id: '1', name: 'Updated');
      when(() => mockRepository.update(any(), any()))
          .thenAnswer((_) async => Right(home));

      final result = await useCase('1', params);

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.name, 'Updated'),
      );
      verify(() => mockRepository.update('1', params)).called(1);
    });

    test('returns failure when not found', () async {
      when(() => mockRepository.update(any(), any()))
          .thenAnswer((_) async => const Left(NotFoundFailure('not found')));

      final result = await useCase('999', fakeSaveHomeParams());

      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
