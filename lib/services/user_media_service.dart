import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/enums.dart';
import 'package:movielingo_app/models/media.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/models/user_episode.dart';
import 'package:movielingo_app/models/user_movie.dart';
import 'package:movielingo_app/models/vocabulary.dart';
import 'package:movielingo_app/services/media_service.dart';
import 'package:movielingo_app/services/vocabulary_service.dart';
import 'package:movielingo_app/singletons/logger.dart';

import '../models/series.dart';
import '../models/user_media.dart';
import '../models/user_vocabulary.dart';

// todo refactor => factory constructor in UserMovie class
final FirebaseFirestore db = FirebaseFirestore.instance;
UserMovie createUserMovie(
    Movie media, String translationLanguage, String mediaLanguage) {
  return UserMovie(
    mediaId: media.id,
    title: media.title,
    progress: 0,
    mediaLanguage: mediaLanguage,
    translationLanguage: translationLanguage,
    imgRef: media.imgRef,
  );
}

// todo refactor => factory constructor in UserMovie class
UserEpisode createUserEpisode(Media media, String translationLanguage,
    String mediaLanguage, int episode, int season) {
  return UserEpisode(
    mediaId: media.id,
    title: "${media.title} S$season E$episode",
    progress: 0,
    mediaLanguage: mediaLanguage,
    translationLanguage: translationLanguage,
    episode: episode,
    season: season,
    seriesTitle: media.title,
    imgRef: media.imgRef,
  );
}

// todo tranlsaion language must be array
// todo vocaburlay document => how to handle multiple translation languages => for every translation language separate vocabulary document. Alternative
// would be to include sentence tranlsation in sentences map but firestore does not create a defualt index for every key in a map, only for top level document fields
// todo vocabulary service => series vocabulary change field from series to season
Future<void> addEpisodeToUser(
    MyUserData user,
    String mediaLanguage,
    String translationLanguage,
    String seriesId,
    int season,
    int episode) async {
  LoggerSingleton().logger.i(
      'Adding episode with series id $seriesId to library of user with id ${user.id}...');
  try {
    var userMediaCollection =
        db.collection('Users').doc(user.id).collection('UserMedia');
    var existingMedia = await userMediaCollection
        .where('mediaId', isEqualTo: seriesId)
        .where('season', isEqualTo: season)
        .where('episode', isEqualTo: episode)
        .limit(1)
        .get();

    if (existingMedia.docs.isNotEmpty) {
      LoggerSingleton().logger.i('Media already exists in user library');
      return;
    }

    Media? series = await getMediaById(mediaLanguage, seriesId);
    if (series == null || (series is! Series)) {
      LoggerSingleton()
          .logger
          .e('No media  id: $series not found or is not a Series.');
    } else {
      UserEpisode userEpisode = createUserEpisode(
          series, translationLanguage, mediaLanguage, episode, season);
      List<Vocabulary> vocabularies = await getEpisodeVocabularies(
          mediaLanguage,
          translationLanguage,
          seriesId,
          user.level ?? CSRFLevel.a1,
          season,
          episode);

      String newEpisodeId =
          await userMediaCollection.add(userEpisode.toMap()).then((value) {
        return value.id;
      });
      addVocabulariesToUser(vocabularies, user.id, newEpisodeId);
      LoggerSingleton().logger.i('Episode added successfully to user library');
    }
  } catch (e) {
    LoggerSingleton()
        .logger
        .e('Error when adding episode to user media library: ', error: e);
  }
}

Future<void> addMovieToUser(MyUserData user, String mediaLanguage,
    String translationLanguage, String movieId) async {
  LoggerSingleton().logger.i(
      'Adding media with id $movieId to library of user with id ${user.id}...');
  try {
    var userMediaCollection =
        db.collection('Users').doc(user.id).collection('UserMedia');
    var existingMedia = await userMediaCollection
        .where('mediaId', isEqualTo: movieId)
        .limit(1)
        .get();

    if (existingMedia.docs.isNotEmpty) {
      LoggerSingleton().logger.i('Media already exists in user library');
      return;
    }

    Media? movie = await getMediaById(mediaLanguage, movieId);
    if (movie == null || (movie is! Movie)) {
      LoggerSingleton()
          .logger
          .e('No media  id: $movieId not found or is not a Movie.');
    } else {
      UserMovie userMovie =
          createUserMovie(movie, translationLanguage, mediaLanguage);
      List<Vocabulary> vocabularies = await getMovieVocabularies(mediaLanguage,
          translationLanguage, movieId, user.level ?? CSRFLevel.a1);

      String newUserMovieId =
          await userMediaCollection.add(userMovie.toMap()).then((value) {
        return value.id;
      });
      addVocabulariesToUser(vocabularies, user.id, newUserMovieId);
      LoggerSingleton().logger.i('Movie added successfully to user library');
    }
  } catch (e) {
    LoggerSingleton()
        .logger
        .e('Error when adding media to library: ', error: e);
  }
}

Future<List<UserMedia>> getUserMedia(String userId) async {
  LoggerSingleton().logger.i('Getting all media for user with id $userId...');
  try {
    var userMediaCollection =
        db.collection('Users').doc(userId).collection('UserMedia');
    QuerySnapshot userMedia = await userMediaCollection.get();
    List<UserMedia> mediaList = [];
    for (var doc in userMedia.docs) {
      var data = doc.data() as Map<String, dynamic>;
      if (data.containsKey('episode')) {
        mediaList.add(UserEpisode.fromSnapshot(doc));
      } else {
        mediaList.add(UserMovie.fromSnapshot(doc));
      }
    }
    for (UserMedia mediaItem in mediaList) {
      LoggerSingleton().logger.i(mediaItem.title);
    }
    return mediaList;
  } catch (e) {
    LoggerSingleton().logger.e('Error parsing userMedia: ', error: e);
    return [];
  }
}

Future<void> updateUserMediaProgress(
    String userId, String mediaId, int progress) async {
  LoggerSingleton().logger.i(
      'Updating progress of media with id $mediaId to $progress for user with id $userId...');
  try {
    var userMediaCollection =
        db.collection('Users').doc(userId).collection('UserMedia');
    var existingMedia = await userMediaCollection
        .where('mediaId', isEqualTo: mediaId)
        .limit(1)
        .get();

    if (existingMedia.docs.isNotEmpty) {
      await userMediaCollection
          .doc(existingMedia.docs.first.id)
          .update({'progress': progress});
      LoggerSingleton().logger.i('Media progress updated successfully');
    } else {
      LoggerSingleton().logger.e('No media found with id: $mediaId');
    }
  } catch (e) {
    LoggerSingleton()
        .logger
        .e('Error when updating media progress: ', error: e);
  }
}

Future<List<Vocabulary>> getDueVocabularySessionForMedia(
    String userId, String mediaId,
    {int sessionSize = 20}) async {
  List<UserVocabulary> vocabularies = await db
      .collection('Users')
      .doc(userId)
      .collection('Vocabularies')
      .where('dueDate', isLessThanOrEqualTo: DateTime.now())
      .where('userMediaId', isEqualTo: mediaId)
      .orderBy('dueDate')
      .limit(sessionSize)
      .get()
      .then((value) =>
          value.docs.map((e) => UserVocabulary.fromSnapshot(e)).toList());
  for (UserVocabulary vocab in vocabularies) {
    LoggerSingleton().logger.i(vocab.wordLemma);
  }
  return vocabularies;
}

Future<int> getAllUserDueVocabulary(String userId) async {
  QuerySnapshot vocabularies = await db
      .collection('Users')
      .doc(userId)
      .collection('Vocabularies')
      .where('dueDate', isLessThanOrEqualTo: DateTime.now())
      .orderBy('dueDate')
      .get();
  LoggerSingleton().logger.i('Total due vocabularies: ${vocabularies.size}');
  return vocabularies.size;
}

Future<void> updateUserVocabulary(
    List<UserVocabulary> vocabularies, String userId) async {
  await db.runTransaction((Transaction transaction) async {
    for (var vocabulary in vocabularies) {
      DocumentReference docRef = db
          .collection('Users')
          .doc(userId)
          .collection('Vocabularies')
          .doc(vocabulary.id);
      transaction.update(docRef, vocabulary.toMap());
    }
  }).then((result) {
    LoggerSingleton().logger.i('Transaction completed successfully');
  }).catchError((error) {
    LoggerSingleton().logger.e('Transaction failed: $error');
  });
}
