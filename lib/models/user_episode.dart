class UserEpisode {
  final String mediaId;
  final String title;
  final int progress;
  final String translationLanguage;
  final String mediaLanguage;

  UserEpisode({
    required this.mediaId,
    required this.title,
    required this.progress,
    required this.translationLanguage,
    required this.mediaLanguage,
  });

  Map<String, dynamic> toMap() {
    return {
      'mediaId': mediaId,
      'title': title,
      'progress': progress,
      'translationLanguage': translationLanguage,
      'mediaLanguage': mediaLanguage,
    };
  }
}
