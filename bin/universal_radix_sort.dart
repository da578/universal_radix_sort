import 'package:universal_radix_sort/src/enums.dart';
import 'package:universal_radix_sort/src/radix_sort_int.dart';

void main() {
  // Sort integers
  final intSorter = UniversalRadixSort<int>(
    dataType: RadixDataType.signedInteger,
    direction: SortDirection.ascending,
  );
  print(intSorter.sort([170, -45, 75, -9000]));
  // Output: [-9000, -45, 75, 170]

  // Sort doubles
  final doubleSorter = UniversalRadixSort<double>(
    dataType: RadixDataType.doublePrecision,
  );
  print(doubleSorter.sort([3.14, -1.25, 0.5]));
  // Output: [-1.25, 0.5, 3.14]

  // Sort strings
  final stringSorter = UniversalRadixSort<String>(
    dataType: RadixDataType.unsignedOrString,
  );
  print(stringSorter.sort(['banana', 'apple', 'cherry']));
  // Output: [apple, banana, cherry]
}
