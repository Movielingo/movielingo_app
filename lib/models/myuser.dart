import 'enums.dart';

class MyUser {
  final String uid;

  MyUser({required this.uid});
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
