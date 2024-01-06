import 'package:cloud_firestore/cloud_firestore.dart';

import 'csrf_vocab_count.dart';
import 'enums.dart';
import 'media.dart';

class Movie extends Media {
  final String director;
  final int lengthMin;
  final int release;
  final CSRFVocabCounts vocabCounts;

  Movie({
    required String id,
    required String title,
    required String description,
    required String imgRef,
    required List<Genre> genres,
    required List<String> translationLanguage,
    required this.director,
    required this.lengthMin,
    required this.release,
    required this.vocabCounts,
  }) : super(
          id: id,
          title: title,
          description: description,
          imgRef: imgRef,
          genres: genres,
          translationLanguage: translationLanguage,
        );

  factory Movie.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Movie(
      id: snapshot.id,
      title: data['title'],
      imgRef: data['imgRef'],
      description: data['description'],
      genres: Genre.getGenresFromSnapshotData(data),
      translationLanguage: data['translationLanguage']
          .map((item) => item.toString())
          .toList()
          .cast<String>(),
      director: data['director'],
      lengthMin: data['lengthMin'],
      release: data['release'],
      vocabCounts: CSRFVocabCounts.fromSnapshot(data),
    );
  }
}
