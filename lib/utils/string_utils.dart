/// Capitalizes the first letter of [text] and returns the modified string.
///
/// Example:
/// ```dart
/// String result = capitalizeFirstLetter('test');
/// print(result); // Output: Test
/// ```
String capitalizeFirstLetter(String text) {
  if (text.isEmpty) return text;
  return text[0].toUpperCase() + text.substring(1);
}
