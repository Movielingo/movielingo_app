abstract class UserMedia {
  final String mediaId;
  final String title;
  final int progress;
  final String translationLanguage;
  final String mediaLanguage;
  final String imgRef;

  UserMedia({
    required this.mediaId,
    required this.title,
    required this.progress,
    required this.translationLanguage,
    required this.mediaLanguage,
    required this.imgRef,
  });

  Map<String, dynamic> toMap() {
    return {
      'mediaId': mediaId,
      'title': title,
      'progress': progress,
      'translationLanguage': translationLanguage,
      'mediaLanguage': mediaLanguage,
      'imgRef': imgRef,
    };
  }
}
