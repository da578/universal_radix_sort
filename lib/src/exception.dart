import 'package:universal_radix_sort/src/enums.dart';

/// A custom exception thrown when Radix Sort operations fail.
class RadixSortException implements Exception {
  /// The specific error code.
  final RadixErrorCode code;

  /// A descriptive message explaining the error.
  final String message;

  const RadixSortException(this.code, this.message);

  @override
  String toString() => 'RadixSortException: [$code] $message';
}
