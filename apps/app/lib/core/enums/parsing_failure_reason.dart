/// Explains why a required persisted value could not be parsed.
enum ParsingFailureReason {
  /// The required field was not present or was null.
  missing,

  /// The value did not have the expected JSON type.
  invalidType,

  /// The value had the expected type but was not valid.
  invalidValue,
}
