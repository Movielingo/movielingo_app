import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/user_media.dart';

class UserMovie extends UserMedia {
  UserMovie({
    required String mediaId,
    required String title,
    required int progress,
    required String translationLanguage,
    required String mediaLanguage,
    required String imgRef,
  }) : super(
          mediaId: mediaId,
          title: title,
          progress: progress,
          translationLanguage: translationLanguage,
          mediaLanguage: mediaLanguage,
          imgRef: imgRef,
        );

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
