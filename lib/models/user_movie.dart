import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/user_media.dart';

class UserMovie extends UserMedia {
  UserMovie({
    required super.mediaId,
    required super.title,
    required super.progress,
    required super.translationLanguage,
    required super.mediaLanguage,
    required super.imgRef,
  });

  factory UserMovie.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserMovie(
      mediaId: data['mediaId'],
      title: data['title'],
      imgRef: data['imgRef'],
      progress: data['progress'],
      mediaLanguage: data['mediaLanguage'],
      translationLanguage: data['translationLanguage'],
    );
  }
}
