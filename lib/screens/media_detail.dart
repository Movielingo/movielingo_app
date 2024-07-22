import 'package:flutter/material.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/services/firebase_storage_service.dart';
import 'package:get/get.dart';

class MediaDetail extends StatelessWidget {
  final Movie movie;

  const MediaDetail({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseStorageService firebaseStorageService =
        Get.find<FirebaseStorageService>();

    return Scaffold(
      appBar: AppBar(
        title: Text(movie.title),
      ),
      body: FutureBuilder<String?>(
        future: firebaseStorageService.getImage(movie.imgRef),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading image'));
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  snapshot.data!,
                  fit: BoxFit.cover,
                ),
                const SizedBox(height: 8),
                Text(
                  movie.title,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                    movie.description), // Assuming you have a description field
              ],
            );
          }
        },
      ),
    );
  }
}
