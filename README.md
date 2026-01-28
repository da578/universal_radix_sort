# Universal Radix Sort

A high-performance, generic Radix Sort implementation for Dart. This package provides a non-comparative sorting algorithm capable of sorting **Integers**, **Doubles**, and **Strings** with $O(n \cdot k)$ time complexity.

It is designed to outperform standard comparison-based sorts (like QuickSort or MergeSort which are $O(n \log n)$) when dealing with large datasets of numbers or fixed-length strings.

## Features

* **Fast**: Linear time complexity $O(n \cdot k)$.
* **Universal**: Supports `int`, `double` (IEEE 754), and `String`.
* **Safe**: Handles `null`, `NaN`, `Infinity` (for doubles), and empty lists gracefully.
* **Flexible**: Supports **Ascending** and **Descending** order.
* **Memory Efficient**: Options for in-place sorting or returning a new list.
* **Low Level Optimization**: Utilizes bitwise operations and byte-level manipulation for maximum speed.

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  universal_radix_sort: ^1.0.0
```

## Usage

**Sorting Integers**
Handles signed integers correctly using bit manipulation to map them to an unsigned space.

```dart
import 'package:universal_radix_sort/universal_radix_sort.dart';

void main() {
  final sorter = UniversalRadixSort<int>(
    dataType: RadixDataType.signedInteger,
    direction: SortDirection.ascending,
  );

  final numbers = [170, -45, 75, -9000, 802, 24, 2, 66];
  final sorted = sorter.sort(numbers);

  print(sorted); // [-9000, -45, 2, 24, 66, 75, 170, 802]
}
```

**Sorting Doubles**
Handles floating-point intricacies (negative zero, denormalized numbers, NaN) via IEEE 754 bit-flipping logic.

```dart
final doubleSorter = UniversalRadixSort<double>(
  dataType: RadixDataType.doublePrecision,
  direction: SortDirection.descending,
);

final doubles = [3.14, -1.25, 0.5, double.nan, -99.9];
// NaN values are typically pushed to the end (or start depending on logic)
print(doubleSorter.sort(doubles));
```

**Sorting Strings**
Uses lexicographical ordering.

```dart
final stringSorter = UniversalRadixSort<String>(
  dataType: RadixDataType.unsignedOrString,
);

final fruits = ['banana', 'apple', 'cherry', 'date'];
print(stringSorter.sort(fruits)); // [apple, banana, cherry, date]
```

## Performance & Complexity

| Metric | Complexity | Description |
| :--- | :--- | :--- |
| **Time** | $O(n \cdot k)$ | Where $n$ is array length and $k$ is the number of passes (bytes). |
| **Space** | $O(n)$ | Requires a temporary buffer of size $n$ for stability. |

- **Comparison**: For large $n$, Radix Sort is generally faster than Quicksort ($O(n \log n)$), provided that $k$ (the size of the data type in bytes) is not excessively large compared to $\log n$.
- **Integers/Doubles**: Uses 64-bit (8 bytes) passes.
- **Strings**: Complexity depends on the length of the longest string in the dataset.

## Technical Details

- **Integers**: Uses an offset binary approach (flipping the sign bit) to correctly sort negative numbers before positives without branching comparisons.
- **Doubles**: Converts `double` to `int` bits. For negative doubles, the bit order is inverted to preserve natural ordering when treated as integers.
- **Strings**: Decomposes strings into UTF-16 code units and applies an MSB (Most Significant Byte) first sorting strategy.

## License
MIT License. See [LICENSE](LICENSE) for details.
