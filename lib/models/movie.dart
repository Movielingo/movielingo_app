import 'package:cloud_firestore/cloud_firestore.dart';

import 'csrf_vocab_count.dart';
import 'enums.dart';
import 'media.dart';

class Movie extends Media {
  final String director;
  final int lengthMin;
  final int release;
  final CSRFVocabCounts vocabCounts;
  // Other Movie-specific properties

  Movie({
    required String id,
    required String title,
    required String description,
    required List<Genre> genres,
    required String translationLanguage,
    required this.director,
    required this.lengthMin,
    required this.release,
    required this.vocabCounts,
  }) : super(
          id: id,
          title: title,
          description: description,
          genres: genres,
          translationLanguage: translationLanguage,
        );

  factory Movie.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Movie(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      genres: Genre.getGenresFromSnapshotData(data),
      translationLanguage: data['translationLanguage'],
      director: data['director'],
      lengthMin: data['lengthMin'],
      release: data['release'],
      vocabCounts: CSRFVocabCounts.fromSnapshot(data),
    );
  }
}
