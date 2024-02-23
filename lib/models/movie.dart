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
    required super.id,
    required super.title,
    required super.description,
    required super.imgRef,
    required super.genres,
    required super.translationLanguage,
    required this.director,
    required this.lengthMin,
    required this.release,
    required this.vocabCounts,
  });

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
