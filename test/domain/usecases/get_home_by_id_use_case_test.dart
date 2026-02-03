import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/usecases/get_home_by_id_use_case.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/mocks.dart';

void main() {
  late MockHomeRepository mockRepository;
  late GetHomeByIdUseCase useCase;

  setUp(() {
    mockRepository = MockHomeRepository();
    useCase = GetHomeByIdUseCase(mockRepository);
  });

  group('GetHomeByIdUseCase', () {
    test('returns home on success', () {
      final home = fakeHome(id: '1');
      when(() => mockRepository.getById('1')).thenReturn(Right(home));

      final result = useCase('1');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.id, '1'),
      );
      verify(() => mockRepository.getById('1')).called(1);
    });

    test('returns failure when not found', () {
      when(() => mockRepository.getById('999'))
          .thenReturn(const Left(NotFoundFailure('not found')));

      final result = useCase('999');

      result.fold(
        (failure) => expect(failure, isA<NotFoundFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
