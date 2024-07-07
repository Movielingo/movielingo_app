import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movielingo_app/models/enums.dart';
import 'package:movielingo_app/models/myuser.dart';

class UserService {
  // get the users collection from firestore
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('Users');

  Future<void> addUser(String userId, String email, String motherTongue,
      String language, String level, bool isProfileComplete) async {
    return await _usersCollection.doc(userId).set({
      'email': email,
      'motherTongue': motherTongue.toLowerCase(),
      'language': language.toLowerCase(),
      'level': level.toLowerCase(),
      'isProfileComplete': isProfileComplete,
    });
  }

  Future<MyUserData> getUser(String uid) async {
    DocumentSnapshot doc = await _usersCollection.doc(uid).get();
    return MyUserData(
      id: doc.id,
      email: doc['email'],
      motherTongue: doc['motherTongue'],
      language: doc['language'],
      level: CSRFLevel.values.firstWhere((e) => e.name == doc['level']),
    );
  }

  Future<void> updateUser(
    String userId,
    String motherTongue,
    String language,
    String level,
    bool isProfileComplete,
  ) async {
    return _usersCollection.doc(userId).update({
      'motherTongue': motherTongue.toLowerCase(),
      'language': language.toLowerCase(),
      'level': level.toLowerCase(),
      'isProfileComplete': isProfileComplete,
    });
  }

  Future<void> deleteUser(String userId) async {
    return _usersCollection.doc(userId).delete();
  }

  Future<bool> checkUserExists(String uid) async {
    var doc = await _usersCollection.doc(uid).get();
    return doc.exists;
  }
}
