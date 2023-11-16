import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/models.dart';
import '../singletons/logger.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;

Future<Movie?> getMovieById(String id) async {
  LoggerSingleton().logger.i('Fetching movie with id $id...');
  final snapshot = await db.collection('movies').doc(id).get();
  try {
    return Movie.fromSnapshot(snapshot);
  } catch (e) {
    LoggerSingleton()
        .logger
        .e('Movie collection does not have a document with id: $id.', e);
  }
}

Future<List<Movie>?> getAllMovies() async {
  LoggerSingleton().logger.i('Fetching all movies...');
  final querySnapshot = await db.collection('movies').get();
  try {
    return querySnapshot.docs.map((doc) {
      return Movie.fromSnapshot(doc);
    }).toList();
  } catch (e) {
    LoggerSingleton().logger.e('Error when fetching all movies: ', e);
  }
}
