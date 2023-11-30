import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';
import 'package:movielingo_app/services/user_media_service.dart';

import '../../services/media_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();
  final FirebaseAuth _user = FirebaseAuth.instance;

  void onPushGetMovieById() {
    getMediaById('EnglishMedia', 'rcSnGoKIurMUB6AG2Rio');
  }

  void onPushGetAllMovies() {
    getAllMovies('EnglishMedia', 'fantasy');
  }

  void onPushGetAllSeries() {
    getAllSeries('EnglishMedia');
  }

  void onPushGetAllMedia() {
    getAllMedia('EnglishMedia', null, 'harry potter');
  }

  void onPushAddMediaToUser() {
    String userId = _user.currentUser?.uid ?? '';
    addMediaToUser(userId, 'EnglishMedia', '5OufgApSdRJIqtYDgNdL', 0);
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
            icon: const Icon(Icons.settings),
            label: const Text('Profile'),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.person),
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
              child: const Text('get media by id'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllMovies,
              child: const Text('get all movies'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllSeries,
              child: const Text('get all series'),
            ),
            ElevatedButton(
              onPressed: onPushGetAllMedia,
              child: const Text('get all media'),
            ),
            ElevatedButton(
                onPressed: onPushAddMediaToUser,
                child: const Text('add Media to User'))
          ],
        ),
      ),
    );
  }
}
