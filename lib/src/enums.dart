/// Defines the data type strategy for the Radix Sort.
enum RadixDataType {
  /// For sorting Strings or raw byte sequences.
  /// Uses purely unsigned comparison logic.
  unsignedOrString,

  /// For standard Dart `int` types.
  /// Applies a sign-bit transformation to handle negative numbers correctly.
  signedInteger,

  /// For `double` floating-point numbers.
  /// Applies IEEE 754 bit transformation to handle decimals and special values.
  doublePrecision,
}

/// Defines the sort order.
enum SortDirection {
  /// Sort from smallest to largest (e.g., 1, 2, 3).
  ascending,

  /// Sort from largest to smallest (e.g., 3, 2, 1).
  descending,
}

/// Defines the order in which bytes/digits are processed.
enum ProcessingOrder {
  /// Least Significant Byte first.
  /// Standard for numeric Radix Sort. Efficient and cache-friendly.
  lsbFirst,

  /// Most Significant Byte first.
  /// Essential for Lexicographical (dictionary) sorting of Strings.
  msbFirst,
}

/// Error codes identifying specific failures during sorting operations.
enum RadixErrorCode {
  /// The operation completed successfully (internal use).
  success,

  /// The input list provided was null.
  nullInput,

  /// The generic type [T] does not match the configured [RadixDataType].
  unsupportedDataType,
}
