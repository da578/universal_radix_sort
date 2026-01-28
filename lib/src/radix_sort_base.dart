/// {@category Sorting}
/// Base classes and enumerations for universal radix sort implementation.

part of 'radix_sort_int.dart';

/// Abstract base class for type-specific radix sort implementations.
abstract class RadixSortBase<T> {
  /// Data type being sorted;
  final RadixDataType dataType;

  /// Sort direction (ascending or descending).
  final SortDirection direction;

  /// Byte processing order (LSB-first or MSB-first).
  final ProcessingOrder processingOrder;

  /// Creates a radix sort instance with the specified configuration.
  const RadixSortBase({
    required this.dataType,
    this.direction = SortDirection.ascending,
    this.processingOrder = ProcessingOrder.lsbFirst,
  });

  /// Sorts the input list and returns a new sorted list.
  ///
  /// This method does not modify the original list.
  ///
  /// ```dart
  /// final sorter = UniversalRadixSort<int>(dataType: RadixDataType.signedInteger);
  /// final sorted = sorter.sort([3, 1, 2]);
  /// print(sorted); // [1, 2, 3]
  /// ```
  List<T> sort(List<T>? input) {
    if (input == null) {
      throw const RadixSortException(
        RadixErrorCode.nullInput,
        'Input list cannot be null',
      );
    }

    if (input.isEmpty) return <T>[];

    final listCopy = List<T>.from(input);
    _sortInternal(listCopy);
    return listCopy;
  }

  /// Sorts the input list in-place.
  ///
  /// This method modifies the original list directly.
  ///
  /// ```dart
  /// final sorter = UniversalRadixSort<int>(dataType: RadixDataType.signedInteger);
  /// final list = [3, 1, 2];
  /// sorter.sortInPlace(list);
  /// print(list); // [1, 2, 3]
  /// ```
  void sortInPlace(List<T>? input) {
    if (input == null) {
      throw const RadixSortException(
        RadixErrorCode.nullInput,
        'Input list cannot be null',
      );
    }

    input.isEmpty ? null : _sortInternal(input);
  }

  /// Internal sorting implementation that modifies the list in-place.
  void _sortInternal(List<T> list);

  void _reverseList(List<T> list) {
    if (direction == SortDirection.descending) {
      list.reversed.toList().asMap().forEach(
        (index, value) => list[index] = value,
      );
    }
  }
}
