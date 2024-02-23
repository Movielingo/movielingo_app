// ignore_for_file: use_super_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/sentence.dart';
import 'package:movielingo_app/models/vocabulary.dart';

import 'enums.dart';

class UserVocabulary extends Vocabulary {
  int box;
  DateTime dueDate;
  String userMediaId;
  String? id;

  UserVocabulary({
    required wordLemma,
    required wordType,
    required wordLevel,
    required sentences,
    required voiceUrl,
    required translationLanguage,
    id,
    required this.dueDate,
    required this.box,
    required this.userMediaId,
  }) : super(
          wordLemma: wordLemma,
          wordType: wordType,
          wordLevel: wordLevel,
          sentences: sentences,
          voiceUrl: voiceUrl,
          translationLanguage: translationLanguage,
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
      translationLanguage: data['translationLanguage'],
      userMediaId: data['userMediaId'],
      id: snapshot.id,
    );
  }

  factory UserVocabulary.fromVocabulary(Vocabulary vocabulary, String mediaId) {
    return UserVocabulary(
      wordLemma: vocabulary.wordLemma,
      wordType: vocabulary.wordType,
      wordLevel: vocabulary.wordLevel,
      sentences: vocabulary.sentences,
      voiceUrl: vocabulary.voiceUrl,
      dueDate: DateTime.now(),
      box: 0,
      translationLanguage: vocabulary.translationLanguage,
      userMediaId: mediaId,
    );
  }
  @override
  Map<String, dynamic> toMap() {
    return {
      'lemma': wordLemma,
      'wordType': wordType.name,
      'wordLevel': wordLevel.name,
      'sentences': sentences.map((e) => e.toMap()).toList(),
      'voiceUrl': voiceUrl,
      'box': box,
      'dueDate': dueDate,
      'translationLanguage': translationLanguage,
      'userMediaId': userMediaId,
    };
  }
}
