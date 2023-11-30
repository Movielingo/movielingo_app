import 'csrf_vocab_count.dart';

class Episode {
  final int episode;
  final String title;
  final String description;
  final int season;
  final CSRFVocabCounts vocabCounts;

  Episode({
    required this.episode,
    required this.title,
    required this.description,
    required this.season,
    required this.vocabCounts,
  });

  factory Episode.fromSnapshotData(dynamic data) {
    Episode a = Episode(
      episode: data['episode'],
      title: data['title'],
      description: data['description'],
      season: data['season'],
      vocabCounts: CSRFVocabCounts.fromSnapshot(data),
    );
    return a;
  }
}
