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
    // Check if media already exists in the user's library
    var userMediaCollection =
        db.collection('Users').doc(userId).collection('UserMedia');
    var existingMedia = await userMediaCollection
        .where('mediaId', isEqualTo: mediaId)
        .limit(1)
        .get();

    if (existingMedia.docs.isNotEmpty) {
      // Media already exists, log and return
      LoggerSingleton().logger.i('Media already exists in user library');
      return;
    }

    // If media doesn't exist, proceed with adding
    Media? media = await getMediaById(mediaLanguage, mediaId);
    var language = mediaLanguage == 'EnglishMedia' ? 'english' : 'french';
    if (media != null) {
      Map<String, dynamic> mediaData;
      if (media is Movie) {
        UserMovie movieUser = UserMovie(
          mediaId: media.id,
          title: media.title,
          progress: progress,
          mediaLanguage: language,
          translationLanguage: media.translationLanguage,
        );
        mediaData = movieUser.toMap();
      } else if (media is Series) {
        UserEpisode episodeUser = UserEpisode(
          mediaId: media.id,
          title: media.title,
          progress: progress,
          mediaLanguage: mediaLanguage,
          translationLanguage: media.translationLanguage,
        );
        mediaData = episodeUser.toMap();
      } else {
        throw Exception('Unknown media type');
      }

      await userMediaCollection.doc().set(mediaData);
      LoggerSingleton().logger.i('Media added successfully to user library');
    } else {
      LoggerSingleton().logger.e('No media found with id: $mediaId');
    }
  } catch (e) {
    LoggerSingleton().logger.e('Error when adding media to library: ', e);
  }
}
