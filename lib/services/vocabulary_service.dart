import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/enums.dart';

import '../models/vocabulary.dart';
import '../singletons/logger.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<void> _processBatch(
    List<Vocabulary> batch, String userId, String mediaId) async {
  WriteBatch batchWrite = db.batch();
  try {
    for (var vocabulary in batch) {
      DocumentReference docRef = db
          .collection('Users')
          .doc(userId)
          .collection('UserMedia')
          .doc(mediaId)
          .collection("Vocabularies")
          .doc();
      batchWrite.set(docRef, vocabulary.toMap());
    }

    await batchWrite.commit();
    return;
  } catch (e) {
    LoggerSingleton().logger.e('Error when adding batch $e to user.');
    return;
  }
}

Future<void> addVocabulariesToUserMedia(
    List<Vocabulary> vocabularies, String userId, String mediaId) async {
  const int batchSize = 500;
  for (int i = 0; i < vocabularies.length; i += batchSize) {
    int end = (i + batchSize < vocabularies.length)
        ? i + batchSize
        : vocabularies.length;
    List<Vocabulary> batch = vocabularies.sublist(i, end);

    try {
      await _processBatch(batch, userId, mediaId);
    } catch (e) {
      LoggerSingleton()
          .logger
          .e('Error when adding voacabulary batch $e to user.');
      return; // todo handle retries later
    }
  }
}

List<String> _getQueryLevels(CSRFLevel level) {
  List<String> queryLevels;
  switch (level) {
    case CSRFLevel.a1:
      queryLevels = ["a1", "a2", "b1", "b2", "c1", "c2"];
      break;
    case CSRFLevel.a2:
      queryLevels = ["b1", "b2", "c1", "c2"];
      break;
    case CSRFLevel.b1:
      queryLevels = ["b2", "c1", "c2"];
      break;
    case CSRFLevel.b2:
      queryLevels = ["c1", "c2"];
      break;
    case CSRFLevel.c1:
      queryLevels = ["c2"];
      break;
    default:
      queryLevels = [];
  }
  return queryLevels;
}

Future<List<Vocabulary>> getMovieVocabularies(
    String mediaLanguage, String mediaId, CSRFLevel level) async {
  List<String> queryLevels = _getQueryLevels(level);

  return await db
      .collection('EnglishMedia')
      .doc(mediaId)
      .collection('Vocabularies')
      .where('wordLevel',
          whereIn:
              queryLevels) // todo filter for translation language => adding in python service
      .get()
      .then((value) =>
          value.docs.map((e) => Vocabulary.fromSnapshot(e)).toList());
}

Future<List<Vocabulary>> getEpisodeVocabularies(String mediaLanguage,
    String mediaId, CSRFLevel level, int season, int episode) async {
  List<String> queryLevels = _getQueryLevels(level);

  return await db
      .collection('EnglishMedia')
      .doc(mediaId)
      .collection('Vocabularies')
      .where('season', isEqualTo: season)
      .where('episode', isEqualTo: episode)
      .where('wordLevel',
          whereIn:
              queryLevels) // todo filter for translation language => adding in python service
      .get()
      .then((value) =>
          value.docs.map((e) => Vocabulary.fromSnapshot(e)).toList());
}
