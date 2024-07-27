import 'package:get/get.dart';
import 'package:movielingo_app/models/user_media.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/user_media_service.dart';

class VocabularyBoxController extends GetxController {
  var vocabularyBox = <Movie>[].obs;
  MyUserData? user;

  @override
  void onInit() {
    super.onInit();
    _loadVocabularyBox();
  }

  @override
  void onClose() {
    _saveVocabularyBox();
    super.onClose();
  }

  void setUser(MyUserData userData) {
    user = userData;
    _syncVocabularyBoxWithDatabase();
  }

  Future<void> addMovieToVocabularyBox(Movie movie) async {
    if (user == null) return;
    await addMovieToUser(
        user!, 'EnglishMedia', movie.translationLanguage.join(', '), movie.id);

    List<UserMedia> userMediaList = await getUserMedia(user!.id);
    if (userMediaList.any((userMedia) => userMedia.mediaId == movie.id) &&
        !vocabularyBox.any((m) => m.id == movie.id)) {
      vocabularyBox.add(movie);
      _saveVocabularyBox();
    }
  }

  void deleteMovieFromVocabularyBox(Movie movie) {
    vocabularyBox.removeWhere((m) => m.id == movie.id);
    _saveVocabularyBox();
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

  Future<void> _syncVocabularyBoxWithDatabase() async {
    if (user == null) return;
    List<UserMedia> userMediaList = await getUserMedia(user!.id);
    vocabularyBox.retainWhere((movie) =>
        userMediaList.any((userMedia) => userMedia.mediaId == movie.id));
    _saveVocabularyBox();
  }
}
