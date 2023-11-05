import 'package:cloud_firestore/cloud_firestore.dart';

enum Genres { family, action, fantasy }

class Movie {
  //final String id;
  final String title;
  final String description;
  // final List<Genres> genres;
  // final int a1VocabCount;
  // final int a2VocabCount;
  // final int b1VocabCount;
  // final int b2VocabCount;
  // final int c1VocabCount;
  // final int c2VocabCount;

  Movie({
    //required this.id,
    required this.title,
    required this.description,
    // required this.genres,
    // required this.a1VocabCount,
    // required this.a2VocabCount,
    // required this.b1VocabCount,
    // required this.b2VocabCount,
    // required this.c1VocabCount,
    // required this.c2VocabCount,
  });
  factory Movie.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    return Movie(
      title: data['title'],
      description: data['description'],
      //id: snapshot.id,
    );
  }
}
