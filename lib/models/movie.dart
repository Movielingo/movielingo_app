import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:movielingo_app/singletons/logger.dart';

import 'csrf_vocab_count.dart';
import 'enums.dart';
import 'media.dart';

final storageRef = FirebaseStorage.instance.ref();

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
      translationLanguage: List<String>.from(data['translationLanguage']),
      director: data['director'],
      lengthMin: data['lengthMin'],
      release: data['release'],
      vocabCounts: CSRFVocabCounts.fromSnapshot(data),
    );
  }

  Future<String> getImageUrl() async {
    final ref = storageRef.child(imgRef);
    LoggerSingleton().logger.i(ref.getDownloadURL());
    // return await ref.getDownloadURL();
    return 'Test';
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      imgRef: json['imgRef'],
      description: json['description'],
      genres: Genre.getGenresFromJson(json['genres']),
      translationLanguage: List<String>.from(json['translationLanguage']),
      director: json['director'],
      lengthMin: json['lengthMin'],
      release: json['release'],
      vocabCounts: CSRFVocabCounts.fromJson(json['vocabCounts']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'imgRef': imgRef,
      'description': description,
      'genres': Genre.genresToJson(genres),
      'translationLanguage': translationLanguage,
      'director': director,
      'lengthMin': lengthMin,
      'release': release,
      'vocabCounts': vocabCounts.toJson(),
    };
  }
}
