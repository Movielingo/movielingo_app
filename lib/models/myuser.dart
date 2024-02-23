import 'enums.dart';

class MyUser {
  final String uid;

  MyUser({required this.uid});
}

class MyUserData {
  final String id;
  final String username;
  final String email;
  final String motherTongue;
  final String language;
  final CSRFLevel level;

  MyUserData(
      {required this.id,
      required this.username,
      required this.email,
      required this.motherTongue,
      required this.language,
      required this.level});
}
