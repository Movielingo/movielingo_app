import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';

import '../../services/movie_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  void on_push_get_movie_by_id() {
    getMovieById('FwJQcNYOHi2rVRRj46j1');
  }

  void on_push_get_all_movies() {
    getAllMovies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('MovieLingo'),
        backgroundColor: Colors.greenAccent,
        elevation: 0.0,
        actions: <Widget>[
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
              child: const Text('get movie by id'),
            ),
            ElevatedButton(
              onPressed: on_push_get_all_movies,
              child: const Text('get all movies'),
            )
          ],
        ),
      ),
    );
  }
}
