import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/core/extensions/list_extensions.dart';

void main() {
  group('ListUpsertExtension', () {
    test('inserts item when existing is null', () {
      final list = [1, 2, 3];

      list.upsert(4, existing: null, test: (e) => e == 4);

      expect(list, [1, 2, 3, 4]);
    });

    test('replaces item when existing is provided and test matches', () {
      final list = ['a', 'b', 'c'];

      list.upsert('B', existing: 'b', test: (e) => e == 'b');

      expect(list, ['a', 'B', 'c']);
    });

    test('does nothing when existing is provided but test finds no match', () {
      final list = [1, 2, 3];

      list.upsert(99, existing: 1, test: (e) => e == 999);

      expect(list, [1, 2, 3]);
    });

    test('inserts into empty list when existing is null', () {
      final list = <int>[];

      list.upsert(1, existing: null, test: (e) => e == 1);

      expect(list, [1]);
    });
  });
}
