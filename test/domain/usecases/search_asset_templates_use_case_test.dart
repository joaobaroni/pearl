import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pearl/core/errors/failures.dart';
import 'package:pearl/domain/models/asset_category.dart';
import 'package:pearl/domain/models/asset_template.dart';
import 'package:pearl/domain/usecases/search_asset_templates_use_case.dart';

import '../../helpers/mocks.dart';

void main() {
  late MockAssetTemplateRepository mockRepository;
  late SearchAssetTemplatesUseCase useCase;

  setUp(() {
    mockRepository = MockAssetTemplateRepository();
    useCase = SearchAssetTemplatesUseCase(mockRepository);
  });

  group('SearchAssetTemplatesUseCase', () {
    test('returns templates on success', () async {
      final templates = [
        const AssetTemplate(
          name: 'Air Conditioner',
          category: AssetCategory.hvac,
          icon: IconData(0),
        ),
      ];
      when(() => mockRepository.search(any()))
          .thenAnswer((_) async => Right(templates));

      final result = await useCase('Air');

      result.fold(
        (failure) => fail('Expected Right'),
        (data) => expect(data.length, 1),
      );
      verify(() => mockRepository.search('Air')).called(1);
    });

    test('returns failure on error', () async {
      when(() => mockRepository.search(any()))
          .thenAnswer((_) async => const Left(StorageFailure('error')));

      final result = await useCase('query');

      result.fold(
        (failure) => expect(failure, isA<StorageFailure>()),
        (_) => fail('Expected Left'),
      );
    });
  });
}
