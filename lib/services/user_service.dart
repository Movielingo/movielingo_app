import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/enums.dart';
import 'package:movielingo_app/models/myuser.dart';

class UserService {
  // get the users collection from firestore
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUser(String userId, String username, String email,
      String motherTongue, String language, String level) async {
    return await _usersCollection.doc(userId).set({
      'username': username,
      'email': email,
      'motherTongue': motherTongue.toLowerCase(),
      'language': language.toLowerCase(),
      'level': level.toLowerCase(),
    });
  }

  Future<MyUserData> getUser(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    return MyUserData(
      id: doc.id,
      username: doc['username'],
      email: doc['email'],
      motherTongue: doc['motherTongue'],
      language: doc['language'],
      level: CSRFLevel.values.firstWhere((e) => e.name == doc['level']),
    );
  }

  Future<void> updateUser(String userId, String username, String motherTongue,
      String language, String level) async {
    return _usersCollection.doc(userId).update({
      'username': username,
      'motherTongue': motherTongue,
      'language': language,
      'level': level,
    });
  }

  Future<void> deleteUser(String userId) async {
    return _usersCollection.doc(userId).delete();
  }
}
