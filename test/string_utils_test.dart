import 'package:flutter_test/flutter_test.dart';
import 'package:movielingo_app/utils/string_utils.dart';

void main() {
  test('capitalizeFirstLetter should capitalize the first letter of a string',
      () {
    // Arrange
    String input = 'hello world';
    String expectedOutput = 'Hello world';

    // Act
    String result = capitalizeFirstLetter(input);

    // Assert
    expect(result, expectedOutput);
  });

  test('capitalizeFirstLetter should return an empty string if input is empty',
      () {
    // Arrange
    String input = '';
    String expectedOutput = '';

    // Act
    String result = capitalizeFirstLetter(input);

    // Assert
    expect(result, expectedOutput);
  });
}
