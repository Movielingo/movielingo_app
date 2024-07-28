import 'package:flutter/material.dart';
import 'package:movielingo_app/models/movie.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:movielingo_app/controllers/app_lifecycle_controller.dart';
import 'package:movielingo_app/models/user_vocabulary.dart';
import 'package:movielingo_app/services/user_media_service.dart';

class Learning extends StatefulWidget {
  final Movie movie;
  final MyUserData user;

  const Learning({required this.movie, required this.user, super.key});

  @override
  State<Learning> createState() => _LearningState();
}

class _LearningState extends State<Learning> {
  final AppLifecycleController _appLifecycleController =
      Get.find<AppLifecycleController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vocabulary Words to learn'),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<UserVocabulary>>(
            future: getDueVocabularySessionForMedia(
                widget.user.id, 'Bg5WjlpynJRQ7ZT1RCo8'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return const Center(child: Text('Error loading vocabulary'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No due vocabulary found'));
              } else {
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.movie.title,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      ...snapshot.data!.map((vocab) => Text(
                            vocab.wordLemma,
                            style: const TextStyle(fontSize: 18),
                          )),
                    ],
                  ),
                );
              }
            },
          ),
          Obx(() {
            if (_appLifecycleController.isBackground.value) {
              return BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ],
      ),
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
