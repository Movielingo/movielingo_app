import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movielingo_app/controllers/vocabulary_box_controller.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/services/firebase_storage_service.dart';

class VocabularyBox extends StatelessWidget {
  const VocabularyBox({super.key});

  @override
  Widget build(BuildContext context) {
    final VocabularyBoxController vocabularyBoxController =
        Get.find<VocabularyBoxController>();
    final FirebaseStorageService firebaseStorageService =
        Get.find<FirebaseStorageService>();

    Widget buildMovieItem(Movie movie) {
      return FutureBuilder<String?>(
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
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: Image.network(
                    snapshot.data!,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    movie.title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
                Flexible(
                  child: Text(
                    movie.imgRef,
                    style: const TextStyle(fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            );
          }
        },
      );
    }

    return Scaffold(
      body: Obx(() {
        if (vocabularyBoxController.vocabularyBox.isEmpty) {
          return const Center(
              child: Text('No movies added to your vocabulary box.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.7,
          ),
          itemCount: vocabularyBoxController.vocabularyBox.length,
          itemBuilder: (context, index) {
            return buildMovieItem(vocabularyBoxController.vocabularyBox[index]);
          },
        );
      }),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            // Implement navigation to the learning screen or functionality
            Get.snackbar('Info', 'Start learning button pressed!');
          },
          child: const Text('Start Learning'),
        ),
      ),
    );
  }
}
