/// {@category Sorting}
/// Radix sort implementation for strings with lexicographical ordering.

part of 'radix_sort_int.dart';

extension _StringRadixSort on UniversalRadixSort {
  /// Orchestrates the sort for Strings.
  ///
  /// Uses **MSB (Most Significant Byte) Radix Sort** logic.
  /// 1. Determines max string length.
  /// 2. Converts Strings to fixed-width arrays of UTF-16 code units.
  /// 3. Sorts using MSB strategy.
  /// 4. Reconstructs strings.
  void _sortStrings(List<String> list) {
    if (list.isEmpty) return;

    // Always use MSB-first for strings (lexicographical order)
    if (processingOrder == ProcessingOrder.lsbFirst) {
      list.sort();
      if (direction == SortDirection.descending) _reverseList(list);
      return;
    }

    // Determine maximum string length for fixed-width processing
    final maxLength = list.fold(0, (maxStr, str) => max(maxStr, str.length));

    // Convert strings to fixed-length UTF-16 code unit arrays
    final codeUnits = _convertStringsToCodeUnits(list, maxLength);

    // Perform LSB-first radix sort on code units
    _radixSortStringsLsbFirst(codeUnits, maxLength);

    // Convert back to strings
    _convertCodeUnitsToStrings(codeUnits, maxLength, list);

    // Reverse for descending order if needed
    if (direction == SortDirection.descending) _reverseList(list);
  }

  /// Converts strings to fixed-length arrays of UTF-16 code units padded with zeros.
  ///
  /// Example: ["a", "bc"] with maxLen 2 -> [[97, 0], [98, 99]]
  List<List<int>> _convertStringsToCodeUnits(
    List<String> strings,
    int maxLength,
  ) => strings.map((str) {
    final units = str.codeUnits;
    // Pad with null character (0) to fixed length
    while (units.length < maxLength) {
      units.add(0);
    }
    return units;
  }).toList();

  /// Performs Radix Sort on the list of code units arrays.
  ///
  /// Uses LSB (Least Significant Byte) approach starting from the
  /// last column (maxLength - 1) down to 0. This guarantees lexicographical order
  /// due to stability.
  void _radixSortStringsLsbFirst(List<List<int>> list, int maxLength) {
    final n = list.length;
    final buffer = List<List<int>>.filled(n, []);

    // Iterate from the last character column to the first
    for (var col = maxLength - 1; col >= 0; col--) {
      _countingSortByColumn(list, buffer, col);

      // Copy back
      for (var i = 0; i < n; i++) {
        list[i] = buffer[i];
      }
    }
  }

  /// Counting sort for a specific column in the string matrix.
  ///
  /// Assumes 16-bit UTF-16 code units (Radix = 65536).
  void _countingSortByColumn(
    List<List<int>> input,
    List<List<int>> output,
    int colIndex,
  ) {
    const radix = 65536; // Full UTF-16 range
    // Allocating 65k ints might be heavy for memory.
    // Optimization: If memory is an issue, Map<int, int> can be used,
    // but Array is O(1) access. We'll stick to array for speed.
    final count = List<int>.filled(radix, 0);
    final len = input.length;

    // Count
    for (var i = 0; i < len; i++) {
      final val = input[i][colIndex];
      count[val]++;
    }

    // Cumulative
    for (var i = 1; i < radix; i++) {
      count[i] += count[i - 1];
    }

    // Build Output
    for (var i = len - 1; i >= 0; i--) {
      final val = input[i][colIndex];
      count[val]--;
      output[count[val]] = input[i];
    }
  }
}

/// Converts code unit arrays back to strings.
void _convertCodeUnitsToStrings(
  List<List<int>> codeUnits,
  int maxLength,
  List<String> output,
) {
  for (var i = 0; i < codeUnits.length; i++) {
    // Remove trailing null characters (padding)
    final units = codeUnits[i];
    while (units.isNotEmpty && units.last == 0) {
      units.removeLast();
    }
    output[i] = String.fromCharCodes(units);
  }
}
