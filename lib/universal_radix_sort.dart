/// {@category Sorting}
/// {@category Algorithms}
///
/// A high-performance Universal Radix Sort library for Dart.
///
/// This library exports the main [UniversalRadixSort] class which allows
/// sorting of [int], [double], and [String] types using non-comparative
/// integer sorting techniques (LSD and MSD Radix Sort).
///
/// Example:
/// ```dart
/// final sorter = UniversalRadixSort<int>(dataType: RadixDataType.signedInteger);
/// final sorted = sorter.sort([3, 1, 2]);
/// ```
library universal_radix_sort;
