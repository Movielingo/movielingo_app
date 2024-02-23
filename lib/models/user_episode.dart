import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/user_media.dart';

class UserEpisode extends UserMedia {
  final int episode;
  final int season;
  final String seriesTitle;

  UserEpisode({
    required super.mediaId,
    required super.title,
    required super.progress,
    required super.translationLanguage,
    required super.mediaLanguage,
    required super.imgRef,
    required this.episode,
    required this.season,
    required this.seriesTitle,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'episode': episode,
      'season': season,
      'seriesTitle': seriesTitle,
    };
  }

  factory UserEpisode.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return UserEpisode(
      mediaId: data['mediaId'],
      title: data['title'],
      imgRef: data['imgRef'],
      progress: data['progress'],
      mediaLanguage: data['mediaLanguage'],
      translationLanguage: data['translationLanguage'],
      episode: data['episode'],
      season: data['season'],
      seriesTitle: data['seriesTitle'],
    );
  }
}
