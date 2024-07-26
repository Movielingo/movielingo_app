import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:movielingo_app/models/movie.dart';

class VocabularyBoxController extends GetxController {
  var vocabularyBox = <Movie>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadVocabularyBox();
  }

  void addMovieToVocabularyBox(Movie movie) {
    if (!vocabularyBox.any((m) => m.id == movie.id)) {
      vocabularyBox.add(movie);
      _saveVocabularyBox();
    }
  }

  void _loadVocabularyBox() async {
    final prefs = await SharedPreferences.getInstance();
    final String? savedBox = prefs.getString('vocabularyBox');
    if (savedBox != null) {
      final List decoded = jsonDecode(savedBox);
      vocabularyBox.assignAll(decoded.map((e) => Movie.fromJson(e)).toList());
    }
  }

  void _saveVocabularyBox() async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedBox =
        jsonEncode(vocabularyBox.map((e) => e.toJson()).toList());
    prefs.setString('vocabularyBox', encodedBox);
  }
}
