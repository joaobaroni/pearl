import 'package:flutter_test/flutter_test.dart';
import 'package:pearl/core/utils/fuzzy_match.dart';

void main() {
  group('fuzzyMatch', () {
    test('empty query matches everything', () {
      expect(fuzzyMatch('', 'anything'), isTrue);
    });

    test('exact match returns true', () {
      expect(fuzzyMatch('Air Conditioner', 'Air Conditioner'), isTrue);
    });

    test('subsequence match returns true', () {
      expect(fuzzyMatch('ac', 'Air Conditioner'), isTrue);
    });

    test('is case insensitive', () {
      expect(fuzzyMatch('AC', 'air conditioner'), isTrue);
      expect(fuzzyMatch('solar', 'SOLAR'), isTrue);
    });

    test('returns false when no match', () {
      expect(fuzzyMatch('xyz', 'Air Conditioner'), isFalse);
    });

    test('characters must appear in order', () {
      expect(fuzzyMatch('ca', 'Air Conditioner'), isFalse);
      expect(fuzzyMatch('ai', 'Air Conditioner'), isTrue);
    });
  });
}
