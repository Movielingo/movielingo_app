import 'package:cloud_firestore/cloud_firestore.dart';

import 'enums.dart';
import 'episode.dart';
import 'media.dart';

class Series extends Media {
  final int releaseFirstEpisode;
  final int releaseLastEpisode;
  final List<Episode> episodeDetails;

  Series({
    required super.id,
    required super.title,
    required super.description,
    required super.imgRef,
    required super.genres,
    required super.translationLanguage,
    required this.releaseFirstEpisode,
    required this.releaseLastEpisode,
    required this.episodeDetails,
  });

  factory Series.fromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data() as Map<String, dynamic>;
    return Series(
      id: snapshot.id,
      title: data['title'],
      description: data['description'],
      imgRef: data['imgRef'],
      genres: Genre.getGenresFromSnapshotData(data),
      translationLanguage: data['translationLanguage']
          .map((item) => item.toString())
          .toList()
          .cast<String>(),
      releaseFirstEpisode: data['releaseFirstEpisode'],
      releaseLastEpisode: data['releaseLastEpisode'],
      episodeDetails: data['episodeDetails']
          .map<Episode>((data) => Episode.fromSnapshotData(data))
          .toList(),
    );
  }
}
