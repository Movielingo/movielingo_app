import 'enums.dart';

class MyUser {
  final String? uid;

  MyUser({this.uid}); // todo why is this a class? Why is this not required?
}

class MyUserData {
  // todo how about renaming to User (and UserId)?
  // todo make everything required
  final String? id;
  final String? username;
  final String? email;
  final String? motherTongue;
  final String? language;
  final CSRFLevel? level;

  MyUserData(
      {this.id,
      this.username,
      this.email,
      this.motherTongue,
      this.language,
      this.level});
}
