import 'package:flutter/material.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/services/firebase_storage_service.dart';
import 'package:get/get.dart';
import 'package:movielingo_app/controllers/vocabulary_box_controller.dart';

class MediaDetail extends StatelessWidget {
  final Movie movie;

  const MediaDetail({required this.movie, super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseStorageService firebaseStorageService =
        Get.find<FirebaseStorageService>();
    final VocabularyBoxController vocabularyBoxController =
        Get.put(VocabularyBoxController());

    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<String?>(
        future: firebaseStorageService.getImage(movie.imgRef),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(child: Text('Error loading image'));
          } else {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
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
                  Text('Directed by ${movie.director}'),
                  const SizedBox(height: 4),
                  Text((movie.release).toString()),
                  const SizedBox(height: 4),
                  Text('${movie.lengthMin.toString()} minutes'),
                  const SizedBox(height: 16),
                  Text(movie.description),
                  const SizedBox(height: 16),
                  const Text('Original language: ENGLISH'),
                  const SizedBox(height: 4),
                  Text(
                      'Available translation languages to study: ${movie.translationLanguage.join(', ').toUpperCase()}'),
                  const SizedBox(height: 16),
                  Text(
                      '${movie.vocabCounts.a1VocabCount.toString()} A1 vocabulary words'),
                  const SizedBox(height: 4),
                  Text(
                      '${movie.vocabCounts.a2VocabCount.toString()} A2 vocabulary words'),
                  const SizedBox(height: 4),
                  Text(
                      '${movie.vocabCounts.b1VocabCount.toString()} B1 vocabulary words'),
                  const SizedBox(height: 4),
                  Text(
                      '${movie.vocabCounts.b2VocabCount.toString()} B2 vocabulary words'),
                  const SizedBox(height: 4),
                  Text(
                      '${movie.vocabCounts.c1VocabCount.toString()} C1 vocabulary words'),
                  const SizedBox(height: 4),
                  Text(
                      '${movie.vocabCounts.c2VocabCount.toString()} C2 vocabulary words'),
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            vocabularyBoxController.addMovieToVocabularyBox(movie);
            Get.snackbar('Success', 'Movie added to your vocabulary box!');
          },
          child: const Text('Add to Vocabulary Box'),
        ),
      ),
    );
  }
}
