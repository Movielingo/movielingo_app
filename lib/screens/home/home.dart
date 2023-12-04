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
    getMediaById('EnglishMedia', 'TImmVhC7VDA8UG1pQGRJ');
  }

  void onPushGetAllMovies() {
    getAllMovies('EnglishMedia', 'german');
  }

  void onPushGetAllSeries() {
    getAllSeries('EnglishMedia', 'german');
  }

  void onPushGetAllMedia() {
    getAllMedia('EnglishMedia', 'german', null, 'harry potter');
  }

  void onPushAddMediaToUser() {
    String userId = _user.currentUser?.uid ?? '';
    addMediaToUser(userId, 'EnglishMedia', 'TOg24pwrOHGHb9vkAzXB', 0);
  }

  void onPushGetUserMedia() {
    String userId = _user.currentUser?.uid ?? '';
    getAllUserMedia(userId);
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
                child: const Text('add Media to User')),
            ElevatedButton(
                onPressed: onPushGetUserMedia,
                child: const Text('get User Media')),
            ElevatedButton(
                onPressed: onPushUpdateUserMediaProgress,
                child: const Text('update User Media Progress to 50')),
          ],
        ),
      ),
    );
  }
}
