import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/create_home_use_case.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockHomeRepository mockRepository;
  late CreateHomeUseCase useCase;

  setUpAll(() {
    registerFallbackValue(fakeSaveHomeParams());
  });

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = CreateHomeUseCase(mockRepository);
  });

  group('CreateHomeUseCase', () {
    test('returns created home on success', () async {
      final params = fakeSaveHomeParams(name: 'New Home');
      final home = fakeHome(id: '1', name: 'New Home');
      when(
        () => mockRepository.create(any()),
      ).thenAnswer((_) async => Right(home));

      final result = await useCase(params);

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.name, 'New Home'),
      );
      verify(() => mockRepository.create(params)).called(1);
    });

    test('returns failure on error', () async {
      when(
        () => mockRepository.create(any()),
      ).thenAnswer((_) async => const Left(StorageFailure('error')));

      final result = await useCase(fakeSaveHomeParams());

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
