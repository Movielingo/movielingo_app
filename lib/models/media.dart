import 'enums.dart';

class Media {
  final String id;
  final String title;
  final String description;
  final String imgRef;
  final List<Genre> genres;
  final String translationLanguage;

  Media({
    required this.id,
    required this.title,
    required this.description,
    required this.imgRef,
    required this.genres,
    required this.translationLanguage,
  });
}
