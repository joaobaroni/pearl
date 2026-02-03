import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/data/repositories/asset_template_repository_impl.dart';
import 'package:pearl/domain/models/asset_category.dart';

void main() {
  late AssetTemplateRepositoryImpl repository;

  setUp(() {
    repository = AssetTemplateRepositoryImpl();
  });

  group('AssetTemplateRepositoryImpl.search', () {
    test('empty query returns all templates', () async {
      final result = await repository.search('');

      result.fold(
        (failure) => fail('Expected Right, got Left: ${failure.message}'),
        (templates) => expect(templates.length, 16),
      );
    });

    test('search by name finds matching template', () async {
      final result = await repository.search('Air Conditioner');

      result.fold(
        (failure) => fail('Expected Right, got Left: ${failure.message}'),
        (templates) {
          expect(templates.length, greaterThanOrEqualTo(1));
          expect(templates.first.name, 'Air Conditioner');
        },
      );
    });

    test('search by category label returns matching items', () async {
      final result = await repository.search('HVAC');

      result.fold(
        (failure) => fail('Expected Right, got Left: ${failure.message}'),
        (templates) {
          expect(templates.length, 4);
          for (final t in templates) {
            expect(t.category, AssetCategory.hvac);
          }
        },
      );
    });

    test('query with no matches returns empty list', () async {
      final result = await repository.search('zzzzz');

      result.fold(
        (failure) => fail('Expected Right, got Left: ${failure.message}'),
        (templates) => expect(templates, isEmpty),
      );
    });
  });
}
