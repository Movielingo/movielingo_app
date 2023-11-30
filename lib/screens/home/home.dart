import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';

import '../../services/media_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  void on_push_get_movie_by_id() {
    getMediaById('EnglishMedia', 'rcSnGoKIurMUB6AG2Rio');
  }

  void on_push_get_all_movies() {
    getAllMovies('EnglishMedia', 'fantasy');
  }

  void on_push_get_all_series() {
    getAllSeries('EnglishMedia');
  }

  void on_push_get_all_media() {
    getAllMedia('EnglishMedia', null, 'harry potter');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              onPressed: on_push_get_movie_by_id,
              child: const Text('get media by id'),
            ),
            ElevatedButton(
              onPressed: on_push_get_all_movies,
              child: const Text('get all movies'),
            ),
            ElevatedButton(
              onPressed: on_push_get_all_series,
              child: const Text('get all series'),
            ),
            ElevatedButton(
              onPressed: on_push_get_all_media,
              child: const Text('get all media'),
            )
          ],
        ),
      ),
    );
  }
}
