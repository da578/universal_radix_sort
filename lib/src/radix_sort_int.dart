/// {@category Sorting}
/// Radix sort implementation for signed integers (`int` type).
library radix_sort_int;

import 'dart:math';
import 'dart:typed_data';

import 'package:universal_radix_sort/src/enums.dart';
import 'package:universal_radix_sort/src/exception.dart';

part 'radix_sort_base.dart';
part 'radix_sort_double.dart';
part 'radix_sort_string.dart';

/// A universal implementation of Radix Sort capable of handling multiple data types.
///
/// The algorithm implemented is a stable sort with $O(n \cdot k)$ time complexity,
/// where $n$ is the number of elements and $k$ is the number of bytes in the element's representation.
///
/// Type definitions:
/// * [T] - The type of data to be sorted (int, double, or String).
class UniversalRadixSort<T> extends RadixSortBase<T> {
  /// Creates a new instance of [UniversalRadixSort].
  ///
  /// [dataType] is required to select the correct transformation logic.
  /// [direction] defaults to [SortDirection.ascending].
  /// [processingOrder] defaults to [ProcessingOrder.lsbFirst].
  UniversalRadixSort({
    required super.dataType,
    super.direction,
    super.processingOrder,
  }) {
    _validateTypeCompatibility();
  }

  void _validateTypeCompatibility() {
    if (dataType == RadixDataType.signedInteger && T != int) {
      throw RadixSortException(
        RadixErrorCode.unsupportedDataType,
        'RadixDataType.signedInteger requires generic type int, but got ${T.runtimeType}',
      );
    }

    if (dataType == RadixDataType.doublePrecision && T != double) {
      throw RadixSortException(
        RadixErrorCode.unsupportedDataType,
        'RadixDataType.doublePrecision requires generic type double, but got ${T.runtimeType}',
      );
    }

    if (dataType == RadixDataType.unsignedOrString && T != String) {
      throw RadixSortException(
        RadixErrorCode.unsupportedDataType,
        'RadixDataType.unsignedOrString with string sorting requires generic type String, but got ${T.runtimeType}',
      );
    }
  }

  @override
  void _sortInternal(List<T> list) {
    switch (dataType) {
      case RadixDataType.signedInteger:
        sortSignedIntegers(list as List<int>);
      case RadixDataType.doublePrecision:
        _sortDoubles(list as List<double>);
      case RadixDataType.unsignedOrString:
        _sortStrings(list as List<String>);
    }
  }

  /// Orchestrates the sort for signed integers.
  ///
  /// 1. Transforms inputs to handle negative numbers correctly.
  /// 2. Performs LSB Radix Sort.
  /// 3. Restores original values.
  /// 4. Reverses if descending order is requested.
  void sortSignedIntegers(List<int> list) {
    // Transform integers by flipping sign bit (MSB of 8-byte representation)
    _transformSignedIntegers(list);

    // Perform LSB-first radix sort on transformed values
    _radixSortIntegersLsbFirst(list);

    // Restore original values
    _restoreSignedIntegers(list);

    // Reverse for descending order if needed
    if (direction == SortDirection.descending) _reverseList(list as List<T>);
  }

  /// Transforms signed integers to sortable unsigned 64-bit representation.
  ///
  /// Correct transformation rules:
  ///   - Negative values: flip ALL bits (~value) → become small positive values
  ///   - Non-negative values: flip ONLY sign bit (value ^ 0x8000000000000000) → become large positive values
  ///
  /// This ensures correct ordering: negatives < positives
  void _transformSignedIntegers(List<int> list) {
    for (var i = 0; i < list.length; i++) {
      // 0x8000000000000000 is the sign bit mask for 64-bit integers
      list[i] ^= 0x8000000000000000;
    }
  }

  /// Restores original signed integers from transformed representation.
  void _restoreSignedIntegers(List<int> list) =>
      // The operation is its own inverse (XOR).
      _transformSignedIntegers(list);

  /// Performs Least Significant Byte (LSB) first Radix Sort.
  ///
  /// Processes the 64-bit integer 8 bits (1 byte) at a time.
  void _radixSortIntegersLsbFirst(List<int> list) {
    const numBytes = 8; // 64-bit integers
    final temp = List<int>.filled(list.length, 0);
    for (var byteIndex = 0; byteIndex < numBytes; byteIndex++) {
      _countingSortByByte(list, temp, byteIndex);
    }
  }

  /// Counting sort implementation for a single byte position in integer list.
  void _countingSortByByte(List<int> input, List<int> output, int byteIndex) {
    const radix = 256;
    final count = List<int>.filled(radix, 0);

    // Count occurrences of each byte value
    for (var i = 0; i < input.length; i++) {
      final byteValue = (input[i] >>> (byteIndex * 8)) & 0xFF;
      count[byteValue]++;
    }

    // Convert to cumulative counts (prefix sum)
    for (var i = 1; i < radix; i++) {
      count[i] += count[i - 1];
    }

    // Build output array in reverse for stability
    for (var i = input.length - 1; i >= 0; i--) {
      final byteValue = (input[i] >> (byteIndex * 8)) & 0xFF;
      final position = --count[byteValue];
      output[position] = input[i];
    }

    // Copy back to input
    input.setRange(0, input.length, output);
  }
}
