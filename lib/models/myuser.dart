import 'enums.dart';

class MyUser {
  final String uid;
  final bool isProfileComplete;

  MyUser({required this.uid, required this.isProfileComplete});
}

class MyUserData {
  final String id;
  final String? email;
  final String? motherTongue;
  final String? language;
  final CSRFLevel? level;

  MyUserData(
      {required this.id,
      this.email,
      this.motherTongue,
      this.language,
      this.level});
}
