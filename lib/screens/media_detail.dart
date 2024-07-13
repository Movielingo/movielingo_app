import 'package:flutter/material.dart';
import 'package:movielingo_app/models/movie.dart'; // Import your Movie model

class MediaDetail extends StatelessWidget {
  final Movie movie;

  const MediaDetail({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
              'https://firebasestorage.googleapis.com/v0/b/movielingo-717e0.appspot.com/o/media%2Ffriends_english.jpeg?alt=media&token=fad7f988-61f4-4b1e-9aa0-661c7340c32b'), // Assuming imgRef is the URL
          const SizedBox(height: 8),
          Text(
            movie.title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(movie.description), // Assuming you have a description field
        ],
      ),
    );
  }
}
