class UserEpisode {
  final String mediaId;
  final String title;
  final int episode;
  final int season;
  final String seriesTitle;
  final int progress;
  final String mediaLanguage;
  final String translationLanguage;

  UserEpisode({
    required this.mediaId,
    required this.title,
    required this.episode,
    required this.season,
    required this.seriesTitle,
    required this.progress,
    required this.mediaLanguage,
    required this.translationLanguage,
  });

  Map<String, dynamic> toMap() {
    return {
      'mediaId': mediaId,
      'title': title,
      'episode': episode,
      'season': season,
      'seriesTitle': seriesTitle,
      'progress': progress,
      'mediaLanguage': mediaLanguage,
      'translationLanguage': translationLanguage,
    };
  }
}
