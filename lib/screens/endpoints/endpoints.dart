import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/auth.dart';
import 'package:movielingo_app/services/user_media_service.dart';

import '../../services/media_service.dart';
import '../../services/user_service.dart';

class Endpoints extends StatelessWidget {
  Endpoints({super.key});

  final AuthService _auth = AuthService();
  final FirebaseAuth _user = FirebaseAuth.instance;
  final UserService userService = UserService();
  void onPushGetMovieById() {
    getMediaById('EnglishMedia', '1gYTGxdrTZHjqgxjunP1');
  }

  void onPushGetSeriesById() {
    getMediaById('EnglishMedia', 'evu4OehE2E4U7vHEW7cP');
  }

  void onPushGetAllMovies() {
    getAllMovies('EnglishMedia', 'german');
  }

  void onPushGetAllMoviesFilter() {
    getAllMovies('EnglishMedia', 'german', ['fantasy']);
  }

  void onPushGetAllSeries() {
    getAllSeries('EnglishMedia', 'german');
  }

  void onPushGetAllSeriesFilter() {
    getAllSeries('EnglishMedia', 'german', ['comedy']);
  }

  void onPushGetAllMedia() {
    getAllMedia('EnglishMedia', 'german', null, 'harry potter');
  }

  void onPushGetDueVocabularySessionForMedia() {
    String userId = _user.currentUser?.uid ?? '';
    getDueVocabularySessionForMedia(userId, 'gNusm32GAmpaVpUWab3m');
  }

  Future<void> onPushAddMovieToUser() async {
    String userId = _user.currentUser?.uid ?? '';
    MyUserData user = await userService.getUser(userId);
    addMovieToUser(user, 'EnglishMedia', 'german', '1gYTGxdrTZHjqgxjunP1');
  }

  Future<void> onPushAddEpisodeToUser() async {
    String userId = _user.currentUser?.uid ?? '';
    MyUserData user = await userService.getUser(userId);
    addEpisodeToUser(
        user, 'EnglishMedia', 'german', 'evu4OehE2E4U7vHEW7cP', 1, 1);
  }

  void onPushGetUserMedia() {
    String userId = _user.currentUser?.uid ?? '';
    getUserMedia(userId);
  }

  void onPushGetAllUserDueVocabulary() {
    String userId = _user.currentUser?.uid ?? '';
    getAllUserDueVocabulary(userId);
  }

  void onPushUpdateUserMediaProgress() {
    String userId = _user.currentUser?.uid ?? '';
    updateUserMediaProgress(userId, 'TOg24pwrOHGHb9vkAzXB', 50);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('MovieLingo'),
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Profile'),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: onPushGetMovieById,
              child: const Text('get media by id (movie)'),
            ),
            ElevatedButton(
              onPressed: onPushGetSeriesById,
              child: const Text('get media by id (series)'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllMovies,
              child: const Text('get all movies'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllMoviesFilter,
              child: const Text('get all movies (genre filter)'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllSeries,
              child: const Text('get all series'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllSeriesFilter,
              child: const Text('get all series (genre filter)'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllMedia,
              child: const Text('get all media (text search)'),
            ),
            ElevatedButton(
                onPressed: onPushAddMovieToUser,
                child: const Text('add Movie to User')),
            ElevatedButton(
                onPressed: onPushAddEpisodeToUser,
                child: const Text('add Episode to User')),
            ElevatedButton(
                onPressed: onPushGetUserMedia,
                child: const Text('get User Media')),
            ElevatedButton(
                onPressed: onPushGetDueVocabularySessionForMedia,
                child: const Text('get due vocabulary session for user media')),
            ElevatedButton(
                onPressed: onPushGetAllUserDueVocabulary,
                child: const Text('get all user due vocabulary')),
            ElevatedButton(
                onPressed: onPushUpdateUserMediaProgress,
                child: const Text('update User Media Progress to 50')),
          ],
        ),
      ),
    );
  }
}
