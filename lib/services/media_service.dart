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
  return null;
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

Future<List<Media>?> getAllMedia(
    String mediaLanguage, String translationLanguage,
    [String? genre, String? searchTerm]) async {
  LoggerSingleton().logger.i(
      'Fetching all media with parameters: genre:[$genre], seachTerm: $searchTerm');
  if (genre != null && searchTerm != null) {
    LoggerSingleton()
        .logger
        .e('Cannot search by genre and searchTerm at the same time.');
    return null;
  }
  List<QueryDocumentSnapshot> documentSnapshots;
  if (searchTerm != null) {
    Map<String, bool> trigrams = _generateTrigrams(searchTerm);
    Query query = db
        .collection(mediaLanguage)
        .where('translationLanguage', arrayContains: translationLanguage);
    trigrams.forEach((key, value) {
      query = query.where(key, isEqualTo: value);
    });
    QuerySnapshot snapshot = await query.get();
    documentSnapshots = snapshot.docs;
  } else if (genre != null) {
    QuerySnapshot snapshot = await db
        .collection(mediaLanguage)
        .where('genres', arrayContains: genre)
        .get();
    documentSnapshots = snapshot.docs.where((doc) {
      var data = doc.data() as Map<String, dynamic>?;
      return data != null &&
          (data['translationLanguage'] as List).contains(translationLanguage);
    }).toList();
  } else {
    QuerySnapshot snapshot = await db
        .collection(mediaLanguage)
        .where('translationLanguage', arrayContains: translationLanguage)
        .get();
    documentSnapshots = snapshot.docs;
  }

  List<Media> media = [];
  for (var doc in documentSnapshots) {
    var data = doc.data() as Map<String, dynamic>;
    try {
      if (data['isSeries'] == true) {
        media.add(Series.fromSnapshot(doc));
      } else {
        media.add(Movie.fromSnapshot(doc));
      }
    } catch (e) {
      LoggerSingleton().logger.e('Error parsing media item: ', error: e);
    }
  }
  for (Media mediaItem in media) {
    LoggerSingleton().logger.i(mediaItem.title);
  }
  return media;
}

Future<List<Movie>?> getAllMovies(
    String mediaLanguage, String translationLanguage,
    [List<String>? genres]) async {
  LoggerSingleton().logger.i('Fetching all movies...');
  List<QueryDocumentSnapshot> documentSnapshots;
  if (genres != null) {
    QuerySnapshot querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: false)
        .where('genres', arrayContainsAny: genres)
        .get();
    documentSnapshots = querySnapshot.docs.where((doc) {
      var data = doc.data() as Map<String, dynamic>?; // Cast to a Map
      return data != null &&
          (data['translationLanguage'] as List).contains(translationLanguage);
    }).toList();
  } else {
    QuerySnapshot querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: false)
        .where('translationLanguage', arrayContains: translationLanguage)
        //.orderBy('genres')
        .get();
    documentSnapshots = querySnapshot.docs;
  }

  try {
    List<Movie> movies = documentSnapshots.map((doc) {
      return Movie.fromSnapshot(doc);
    }).toList();
    for (Movie movie in movies) {
      LoggerSingleton().logger.i(movie.title);
      LoggerSingleton().logger.i(movie.imgRef);
    }
    return movies;
  } catch (e) {
    LoggerSingleton().logger.e('Error when fetching all movies: ', error: e);
    return null;
  }
}

Future<List<Series>?> getAllSeries(
    String mediaLanguage, String translationLanguage,
    [List<String>? genre]) async {
  LoggerSingleton().logger.i('Fetching all series...');
  List<DocumentSnapshot> documentSnapshots;
  if (genre != null) {
    QuerySnapshot querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: true)
        .where('genres', arrayContainsAny: genre)
        .get();
    documentSnapshots = querySnapshot.docs.where((doc) {
      var data = doc.data() as Map<String, dynamic>?; // Cast to a Map
      return data != null &&
          (data['translationLanguage'] as List).contains(translationLanguage);
    }).toList();
  } else {
    QuerySnapshot querySnapshot = await db
        .collection(mediaLanguage)
        .where('isSeries', isEqualTo: true)
        .where('translationLanguage', arrayContains: translationLanguage)
        .get();
    documentSnapshots = querySnapshot.docs;
  }

  try {
    List<Series> series = documentSnapshots.map((doc) {
      return Series.fromSnapshot(doc);
    }).toList();
    for (Series seriesItem in series) {
      LoggerSingleton().logger.i(seriesItem.title);
    }
  } catch (e) {
    LoggerSingleton().logger.e('Error when fetching all series: ', error: e);
  }
  return null;
}
