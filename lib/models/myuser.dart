class MyUser {
  final String? uid;

  MyUser({this.uid});
}

class MyUserData {
  final String? uid;
  final String? username;
  final String? email;
  final String? motherTongue;
  final String? language;
  final String? level;

  MyUserData(
      {this.uid,
      this.username,
      this.email,
      this.motherTongue,
      this.language,
      this.level});
}
