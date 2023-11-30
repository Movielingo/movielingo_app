enum Genre {
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
  thriller;

  static List<Genre> getGenresFromSnapshotData(Map<String, dynamic> data) {
    List<String> genreList = List<String>.from(data['genres']);
    return genreList.map((str) {
      return Genre.values.firstWhere((e) => e.toString().split('.')[1] == str,
          orElse: () => throw ArgumentError('Invalid genre name: $str'));
    }).toList();
  }
}
