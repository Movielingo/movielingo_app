import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/media.dart';
import '../models/movie.dart';
import '../models/series.dart';
import '../singletons/logger.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<Media?> getMediaById(String mediaLanguage, String id) async {
  LoggerSingleton().logger.i('Fetching media with id $id...');
  final snapshot = await db.collection(mediaLanguage).doc(id).get();
  if (snapshot.data() == null) {
    LoggerSingleton().logger.e(
          '$mediaLanguage collection does not have a document with id: $id.',
        );
  } else {
    if (snapshot.data()?['isSeries'] == false) {
      Movie movie = Movie.fromSnapshot(snapshot);
      LoggerSingleton().logger.i('Returning movie with title ${movie.title}');
      return movie;
    } else {
      Series series = Series.fromSnapshot(snapshot);

      LoggerSingleton().logger.i('Returning series with title ${series.title}');
      return series;
    }
  }
}

Map<String, bool> _generateTrigrams(String text) {
  text = text.toLowerCase();
  Map<String, bool> trigrams = {};
  String formattedText = text.toLowerCase();
  for (int i = 0; i < formattedText.length - 2; i++) {
    String trigram = formattedText.substring(i, i + 3);
    trigrams[trigram] = true;
  }
  return trigrams;
}

Future<List<Media>?> getAllMedia(String mediaLanguage,
    [String? genre, String? searchTerm]) async {
  LoggerSingleton().logger.i(
      'Fetching all media with parameters: genre:[$genre], seachTerm: $searchTerm');
  if (genre != null && searchTerm != null) {
    LoggerSingleton()
        .logger
        .e('Cannot search by genre and searchTerm at the same time.');
    return null;
  }
  QuerySnapshot snapshot;
  if (searchTerm != null) {
    Map<String, bool> trigrams = _generateTrigrams(searchTerm);
    Query query = db.collection(mediaLanguage);
    trigrams.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });
    snapshot = await query.get();
  } else if (genre != null) {
    snapshot = await db
        .collection(mediaLanguage)
        .where('genres', arrayContains: genre)
        .get();
  } else {
    snapshot = await db.collection(mediaLanguage).get();
  }

  List<Media> media = [];
  for (var doc in snapshot.docs) {
    var data = doc.data() as Map<String, dynamic>;
    if (data != null) {
      try {
        if (data['isSeries'] == true) {
          media.add(Series.fromSnapshot(doc));
        } else {
          media.add(Movie.fromSnapshot(doc));
        }
      } catch (e) {
        LoggerSingleton().logger.e('Error parsing media item: ', e);
      }
    }
  }
  for (Media mediaItem in media) {
    LoggerSingleton().logger.i(mediaItem.title);
  }
  return media;
}

Future<List<Movie>?> getAllMovies(String mediaLanguage, [String? genre]) async {
  LoggerSingleton().logger.i('Fetching all series...');
  QuerySnapshot querySnapshot;
  if (genre != null) {
    querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: false)
        .where('genres', arrayContains: genre)
        .get();
  } else {
    querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: false)
        .get();
  }

  try {
    List<Movie> movies = querySnapshot.docs.map((doc) {
      return Movie.fromSnapshot(doc);
    }).toList();
    for (Movie movie in movies) {
      LoggerSingleton().logger.i(movie.title);
    }
  } catch (e) {
    LoggerSingleton().logger.e('Error when fetching all movies: ', e);
  }
}

Future<List<Series>?> getAllSeries(String mediaLanguage,
    [String? genre]) async {
  LoggerSingleton().logger.i('Fetching all series...');
  QuerySnapshot querySnapshot;
  if (genre != null) {
    querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: true)
        .where('genres', arrayContains: genre)
        .get();
  } else {
    querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: true)
        .get();
  }

  try {
    List<Series> series = querySnapshot.docs.map((doc) {
      return Series.fromSnapshot(doc);
    }).toList();
    for (Series seriesItem in series) {
      LoggerSingleton().logger.i(seriesItem.title);
    }
  } catch (e) {
    LoggerSingleton().logger.e('Error when fetching all series: ', e);
  }
}
