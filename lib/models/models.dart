import 'package:cloud_firestore/cloud_firestore.dart';

enum Genres {
  family,
  action,
  fantasy,
  drama,
  romance,
  adventure,
  comedy,
  crime,
  horror,
  documentary,
  scienceFiction,
  thriller
}

class Movie {
  final String id;
  final String title;
  final String description;
  final List<Genres> genres;
  final int a1VocabCount;
  final int a2VocabCount;
  final int b1VocabCount;
  final int b2VocabCount;
  final int c1VocabCount;
  final int c2VocabCount;

  Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.genres,
    required this.a1VocabCount,
    required this.a2VocabCount,
    required this.b1VocabCount,
    required this.b2VocabCount,
    required this.c1VocabCount,
    required this.c2VocabCount,
  });
  factory Movie.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;

    List<String> genreList = List<String>.from(data['genres']);

    return Movie(
      title: data['title'],
      description: data['description'],
      a1VocabCount: data['a1VocabCount'],
      a2VocabCount: data['a2VocabCount'],
      b1VocabCount: data['b1VocabCount'],
      b2VocabCount: data['b2VocabCount'],
      c1VocabCount: data['c1VocabCount'],
      c2VocabCount: data['c2VocabCount'],
      id: snapshot.id,
      genres: genreList.map((str) {
        return Genres.values.firstWhere(
            (e) => e.toString().split('.')[1] == str,
            orElse: () => throw ArgumentError('Invalid genre name: $str'));
      }).toList(),
    );
  }
}
