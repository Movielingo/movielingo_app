import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/sentence.dart';

import 'enums.dart';

class Vocabulary {
  final String wordLemma;
  final WordType wordType;
  final CSRFLevel wordLevel;
  final List<Sentence> sentences;
  final String voiceUrl;
  final String translationLanguage;

  Vocabulary({
    required this.wordLemma,
    required this.wordType,
    required this.wordLevel,
    required this.sentences,
    required this.voiceUrl,
    required this.translationLanguage,
  });

  factory Vocabulary.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Vocabulary(
      wordLemma: data['lemma'],
      wordType: WordType.values.firstWhere((e) => e.name == data['wordType']),
      wordLevel:
          CSRFLevel.values.firstWhere((e) => e.name == data['wordLevel']),
      sentences: data['sentences']
          .map<Sentence>((data) => Sentence.fromSnapshot(data))
          .toList(),
      voiceUrl: data['voiceUrl'],
      translationLanguage: data['translationLanguage'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lemma': wordLemma,
      'wordType': wordType.name,
      'wordLevel': wordLevel.name,
      'sentences': sentences.map((e) => e.toMap()).toList(),
      'voiceUrl': voiceUrl,
      'translationLanguage': translationLanguage,
    };
  }
}
