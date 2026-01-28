/// {@category Sorting}
///
/// Extension for handling IEEE 754 Double Precision Floating Point sorting.

part of 'radix_sort_int.dart';

extension _DoubleRadixSort on UniversalRadixSort {
  /// Orchestrates the sort for floating-point numbers.
  ///
  /// 1. Transforms `double` to sortable `int` (IEEE 754 mapping).
  /// 2. Sorts the integers.
  /// 3. Restores `double` values.
  void _sortDoubles(List<double> list) {
    if (list.isEmpty) return;

    // Transform doubles to their 64-bit integer representation
    final transformed = _transformDoubles(list);

    // Sort transformed integers using integer radix sort
    _radixSortIntegersLsbFirst(transformed);

    // Restore integers back to doubles into the original list
    _restoreDoubles(transformed, list);

    // Direction handling
    if (direction == SortDirection.descending) _reverseList(list);
  }

  /// Transforms a list of doubles into a list of sortable 64-bit integers.
  ///
  /// **Logic:**
  /// * **Positive numbers**: Sign bit is 0. We flip the sign bit to 1.
  ///     (Maps +0.0 -> 0x8000...)
  /// * **Negative numbers**: Sign bit is 1. We flip *all* bits.
  ///     (Maps -0.0 -> 0x7FFF... and large negatives to small integers)
  ///
  /// This transformation ensures that the resulting integers, when sorted
  /// as unsigned values, represent the correct order of the original doubles.
  List<int> _transformDoubles(List<double> input) {
    final output = <int>[];
    final buffer = ByteData(8);

    for (final value in input) {
      if (value.isNaN) {
        output.add(0xFFFFFFFFFFFFFFFF); // Max unsigned value
        continue;
      }

      buffer.setFloat64(0, value, Endian.little);
      var bits = buffer.getUint64(0, Endian.little);

      // IEEE 754 transformation
      value.isNegative
          ? // Flip ALL bits for negatives (including -0.0)
            bits = ~bits
          : // Flip ONLY sign bit for non-negatives
            bits ^= 0x8000000000000000;

      output.add(bits);
    }
    return output;
  }

  /// Restores original double values from transformed representation.
  void _restoreDoubles(List<int> transformed, List<double> output) {
    final buffer = ByteData(8);

    for (var i = 0; i < transformed.length; i++) {
      var bits = transformed[i].toUnsigned(64);

      // Check for NaN marker
      if (bits == -1) {
        output[i] = double.nan;
        continue;
      }

      // Reverse transformation
      (bits & 0x8000000000000000) == 0
          ? // Was negative: flip all bits back
            bits = ~bits
          : // Was non-negative: flip sign bit back
            bits ^= 0x8000000000000000;

      buffer.setUint64(0, bits, Endian.little);
      output[i] = buffer.getFloat64(0, Endian.little);
    }
  }
}
