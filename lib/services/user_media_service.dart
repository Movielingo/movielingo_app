import 'package:movielingo_app/models/media.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/models/series.dart';
import 'package:movielingo_app/models/user_episode.dart';
import 'package:movielingo_app/models/user_movie.dart';
import 'package:movielingo_app/services/media_service.dart';
import 'package:movielingo_app/singletons/logger.dart';

Future<void> addMediaToUser(
    String userId, String mediaLanguage, String mediaId, int progress) async {
  LoggerSingleton()
      .logger
      .i('Adding media with id $mediaId to library of user with id $userId...');
  try {
    var userMediaCollection =
        db.collection('Users').doc(userId).collection('UserMedia');
    // Check if media already exists in the user's library
    var existingMedia = await userMediaCollection
        .where('mediaId', isEqualTo: mediaId)
        .limit(1)
        .get();

    if (existingMedia.docs.isNotEmpty) {
      // Media already exists, log and return
      LoggerSingleton().logger.i('Media already exists in user library');
      return;
    }

    Media? media = await getMediaById(mediaLanguage, mediaId);
    var language = mediaLanguage == 'EnglishMedia' ? 'english' : 'french';
    if (media != null) {
      if (media is Movie) {
        UserMovie movieUser = UserMovie(
          mediaId: media.id,
          title: media.title,
          progress: progress,
          mediaLanguage: language,
          translationLanguage: media.translationLanguage,
        );
        await userMediaCollection.doc().set(movieUser.toMap());
      } else if (media is Series) {
        for (var episode in media.episodeDetails) {
          UserEpisode episodeUser = UserEpisode(
            mediaId: media.id,
            title: episode.title,
            episode: episode.episode,
            season: episode.season,
            seriesTitle: media.title,
            progress: progress,
            mediaLanguage: language,
            translationLanguage: media.translationLanguage,
          );
          await userMediaCollection.doc().set(episodeUser.toMap());
        }
      } else {
        throw Exception('Unknown media type');
      }
      LoggerSingleton().logger.i('Media added successfully to user library');
    } else {
      LoggerSingleton().logger.e('No media found with id: $mediaId');
    }
  } catch (e) {
    LoggerSingleton().logger.e('Error when adding media to library: ', e);
  }
}

// get all media from user and return as a list of UserMovie if its movie and UserEpisode if its episode
Future<List<dynamic>> getAllUserMedia(String userId) async {
  LoggerSingleton().logger.i('Getting all media for user with id $userId...');
  try {
    var userMediaCollection =
        db.collection('Users').doc(userId).collection('UserMedia');
    var userMedia = await userMediaCollection.get();
    List<dynamic> mediaList = [];
    for (var media in userMedia.docs) {
      if (media['mediaLanguage'] == 'english') {
        UserMovie userMovie = UserMovie(
          mediaId: media['mediaId'],
          title: media['title'],
          progress: media['progress'],
          mediaLanguage: media['mediaLanguage'],
          translationLanguage: media['translationLanguage'],
        );
        mediaList.add(userMovie);
      } else {
        UserEpisode userEpisode = UserEpisode(
          mediaId: media['mediaId'],
          title: media['title'],
          episode: media['episode'],
          season: media['season'],
          seriesTitle: media['seriesTitle'],
          progress: media['progress'],
          mediaLanguage: media['mediaLanguage'],
          translationLanguage: media['translationLanguage'],
        );
        mediaList.add(userEpisode);
      }
    }
    LoggerSingleton().logger.i('Media retrieved successfully');
    print(mediaList);
    return mediaList;
  } catch (e) {
    LoggerSingleton().logger.e('Error when getting media: ', e);
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
    LoggerSingleton().logger.e('Error when updating media progress: ', e);
  }
}
