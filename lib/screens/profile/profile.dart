import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/user.dart';

class Profile extends StatelessWidget {
  Profile({Key? key}) : super(key: key);

  final UserService _user = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    String userId = _auth.currentUser?.uid ?? '';
    return Scaffold(
      backgroundColor: const Color.fromRGBO(185, 246, 202, 1),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.greenAccent,
        elevation: 0.0,
      ),
      body: FutureBuilder<MyUserData>(
        future: _user.getUser(userId),
        builder: (BuildContext context, AsyncSnapshot<MyUserData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              MyUserData? data = snapshot.data;
              return Column(
                children: <Widget>[
                  Text(
                      'Username: ${data?.username}\nEmail: ${data?.email}\nMother Tongue: ${data?.motherTongue}\nLanguage: ${data?.language}\nLevel: ${data?.level}'),
                  ElevatedButton(
                    child: const Text('Edit Profile'),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Column(
                              children: <Widget>[
                                TextFormField(
                                  initialValue: data?.username,
                                  decoration: const InputDecoration(
                                      labelText: 'Username'),
                                ),
                                TextFormField(
                                  initialValue: data?.motherTongue,
                                  decoration: const InputDecoration(
                                      labelText: 'Mother Tongue'),
                                ),
                              ],
                            );
                          });
                    },
                  ),
                ],
              );
            }
          }
        },
      ),
    );
  }
}
