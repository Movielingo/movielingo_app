class CSRFVocabCounts {
  final int a1VocabCount;
  final int a2VocabCount;
  final int b1VocabCount;
  final int b2VocabCount;
  final int c1VocabCount;
  final int c2VocabCount;

  CSRFVocabCounts(
      {required this.a1VocabCount,
      required this.a2VocabCount,
      required this.b1VocabCount,
      required this.b2VocabCount,
      required this.c1VocabCount,
      required this.c2VocabCount});

  factory CSRFVocabCounts.fromSnapshot(Map<String, dynamic> data) {
    return CSRFVocabCounts(
        a1VocabCount: data['a1VocabCount'],
        a2VocabCount: data['a2VocabCount'],
        b1VocabCount: data['b1VocabCount'],
        b2VocabCount: data['b2VocabCount'],
        c1VocabCount: data['c1VocabCount'],
        c2VocabCount: data['c2VocabCount']);
  }
}
