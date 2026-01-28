import 'package:universal_radix_sort/src/enums.dart';
import 'package:universal_radix_sort/src/exception.dart';
import 'package:universal_radix_sort/src/radix_sort_int.dart';
import 'package:test/test.dart';

void main() {
  group('Integer Sorting', () {
    test('sorts signed integers in ascending order', () {
      final sorter = UniversalRadixSort<int>(
        dataType: RadixDataType.signedInteger,
        direction: SortDirection.ascending,
      );
      final result = sorter.sort([170, -45, 75, -9000, 802, -24, 2, 66, 0, -1]);
      expect(result, equals([-9000, -45, -24, -1, 0, 2, 66, 75, 170, 802]));
    });

    test('sorts signed integers in descending order', () {
      final sorter = UniversalRadixSort<int>(
        dataType: RadixDataType.signedInteger,
        direction: SortDirection.descending,
      );
      final result = sorter.sort([170, -45, 75, -9000, 802, -24, 2, 66, 0, -1]);
      expect(result, equals([802, 170, 75, 66, 2, 0, -1, -24, -45, -9000]));
    });

    test('handles empty list', () {
      final sorter = UniversalRadixSort<int>(
        dataType: RadixDataType.signedInteger,
      );
      expect(sorter.sort([]), isEmpty);
    });

    test('handles single element', () {
      final sorter = UniversalRadixSort<int>(
        dataType: RadixDataType.signedInteger,
      );
      expect(sorter.sort([42]), equals([42]));
    });

    test('throws on null input', () {
      final sorter = UniversalRadixSort<int>(
        dataType: RadixDataType.signedInteger,
      );
      expect(
        () => sorter.sort(null),
        throwsA(
          isA<RadixSortException>().having(
            (e) => e.code,
            'code',
            RadixErrorCode.nullInput,
          ),
        ),
      );
    });
  });

  group('Double Sorting', () {
    test('sorts doubles in ascending order with negatives', () {
      final sorter = UniversalRadixSort<double>(
        dataType: RadixDataType.doublePrecision,
        direction: SortDirection.ascending,
      );
      final result = sorter.sort([
        3.14,
        -1.25,
        0.5,
        -99.9,
        2.0,
        0.0,
        -0.001,
        100.0,
      ]);
      // Gunakan approximate equality untuk floating point
      expect(result[0], closeTo(-99.9, 0.0001));
      expect(result[1], closeTo(-1.25, 0.0001));
      expect(result[2], closeTo(-0.001, 0.0001));
      expect(result[3], closeTo(0.0, 0.0001));
      expect(result[4], closeTo(0.5, 0.0001));
      expect(result[5], closeTo(2.0, 0.0001));
      expect(result[6], closeTo(3.14, 0.0001));
      expect(result[7], closeTo(100.0, 0.0001));
    });

    test('handles special double values', () {
      final sorter = UniversalRadixSort<double>(
        dataType: RadixDataType.doublePrecision,
        direction: SortDirection.ascending,
      );
      final result = sorter.sort([
        double.nan,
        double.infinity,
        -double.infinity,
        0.0,
      ]);
      expect(result[0], -double.infinity);
      expect(result[1], 0.0);
      expect(result[2], double.infinity);
      expect(result[3].isNaN, isTrue);
    });
  });

  group('String Sorting', () {
    test('sorts strings lexicographically ascending', () {
      final sorter = UniversalRadixSort<String>(
        dataType: RadixDataType.unsignedOrString,
        direction: SortDirection.ascending,
      );
      final result = sorter.sort(['banana', 'apple', 'zebra', 'fig', 'cherry']);
      expect(result, equals(['apple', 'banana', 'cherry', 'fig', 'zebra']));
    });

    test('sorts strings lexicographically descending', () {
      final sorter = UniversalRadixSort<String>(
        dataType: RadixDataType.unsignedOrString,
        direction: SortDirection.descending,
      );
      final result = sorter.sort(['banana', 'apple', 'zebra', 'fig', 'cherry']);
      expect(result, equals(['zebra', 'fig', 'cherry', 'banana', 'apple']));
    });

    test('handles strings with different lengths', () {
      final sorter = UniversalRadixSort<String>(
        dataType: RadixDataType.unsignedOrString,
        direction: SortDirection.ascending,
      );
      final result = sorter.sort(['a', 'aa', 'aaa', 'b', 'bb']);
      expect(result, equals(['a', 'aa', 'aaa', 'b', 'bb']));
    });
  });

  group('Error Handling', () {
    test('throws on type mismatch', () {
      expect(
        () => UniversalRadixSort<String>(dataType: RadixDataType.signedInteger),
        throwsA(isA<RadixSortException>()),
      );
    });
  });
}
