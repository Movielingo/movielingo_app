import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  // collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String userId, String name, String email) async {
    return await _usersCollection.doc(userId).set({
      'name': name,
      'email': email,
    });
  }

/*   Future<DocumentSnapshot> getUser(String userId) async {
    return _usersCollection.doc(userId).get();
  } */

/*   Future<void> updateUser(String userId, String name, String email) async {
    return _usersCollection.doc(userId).update({
      'name': name,
      'email': email,
    });
  } */

/*   Future<void> deleteUser(String userId) async {
    return _usersCollection.doc(userId).delete();
  } */
}
