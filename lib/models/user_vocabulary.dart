import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/sentence.dart';
import 'package:movielingo_app/models/vocabulary.dart';

import 'enums.dart';

class UserVocabulary extends Vocabulary {
  int box;
  DateTime dueDate;

  UserVocabulary({
    required wordLemma,
    required wordType,
    required wordLevel,
    required sentences,
    required voiceUrl,
    required this.dueDate,
    required this.box,
  }) : super(
          wordLemma: wordLemma,
          wordType: wordType,
          wordLevel: wordLevel,
          sentences: sentences,
          voiceUrl: voiceUrl,
        );

  factory UserVocabulary.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserVocabulary(
      wordLemma: data['lemma'],
      wordType: WordType.values.firstWhere((e) => e.name == data['wordType']),
      wordLevel:
          CSRFLevel.values.firstWhere((e) => e.name == data['wordLevel']),
      sentences: data['sentences']
          .map<Sentence>((data) => Sentence.fromSnapshot(data))
          .toList(),
      voiceUrl: data['voiceUrl'],
      dueDate: data['dueDate'].toDate(),
      box: data['box'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'lemma': wordLemma,
      'wordType': wordType.name,
      'wordLevel': wordLevel.name,
      'sentences': sentences.map((e) => e.toMap()).toList(),
      'voiceUrl': voiceUrl,
      'box': box,
      'dueDate': dueDate,
    };
  }
}
