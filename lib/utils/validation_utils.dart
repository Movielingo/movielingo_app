class ValidationUtils {
  static String? validatePassword(String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter a password';
    } else if (val.length < 8) {
      return 'Must be at least 8 characters long';
    } else if (!RegExp(r'[a-z]').hasMatch(val)) {
      return 'Must contain at least one lowercase character';
    } else if (!RegExp(r'[A-Z]').hasMatch(val)) {
      return 'Must contain at least one uppercase character';
    } else if (!RegExp(r'[0-9]').hasMatch(val)) {
      return 'Must contain at least one numeric character';
    } else if (!RegExp(r'[^\w\s]').hasMatch(val)) {
      return 'Must contain at least one non-alphanumeric character';
    }
    return null;
  }

  static const List<String> motherTongues = [
    'English',
    'Mandarin Chinese',
    'Hindi',
    'Spanish',
    'French',
    'Standard Arabic',
    'Bengali',
    'Russian',
    'Portuguese',
    'Urdu',
    'Indonesian',
    'German',
    'Japanese',
    'Swahili',
    'Marathi',
    'Telugu',
    'Turkish',
    'Tamil',
    'Vietnamese',
    'Italian',
    'Egyptian Arabic',
    'Hausa',
    'Thai',
    'Korean',
    'Persian',
    'Gujarati',
    'Philippine Filipino',
    'Punjabi',
    'Polish',
    'Ukrainian'
  ];
}
