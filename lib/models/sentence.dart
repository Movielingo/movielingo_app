class Sentence {
  final String sentence;
  final String translation;
  final String timestamp;

  Sentence({
    required this.sentence,
    required this.translation,
    required this.timestamp,
  });

  factory Sentence.fromSnapshot(Map<String, dynamic> data) {
    return Sentence(
      sentence: data['sentence'],
      translation: data['translation'],
      timestamp: data['timestamp'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'sentence': sentence,
      'translation': translation,
      'timestamp': timestamp,
    };
  }
}
