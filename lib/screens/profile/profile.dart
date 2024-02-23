import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/user_service.dart';
import 'package:movielingo_app/singletons/logger.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserService _user = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // text field state
  late String username;
  late String motherTongue;
  late String language;
  late String level;
  late String error;

  @override
  void initState() {
    super.initState();
    username = '';
    motherTongue = '';
    language = '';
    level = '';
    error = '';
    _loadInitialData();
  }

  void _loadInitialData() async {
    String userId = _auth.currentUser!.uid;
    MyUserData? data = await _user.getUser(userId);
    setState(() {
      username = data.username;
      motherTongue = data.motherTongue;
      language = data.language;
      // todo level = data.level ?? '';
    });
  }

  void _deleteUser() async {
    try {
      String userId = _auth.currentUser?.uid ?? '';
      await _user.deleteUser(userId);
      await _auth.currentUser?.delete();
      await _auth.signOut();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      LoggerSingleton().logger.e(e.toString());
      setState(() {
        error = 'Failed to delete user';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Username: $username',
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            Text('Mother Tongue: $motherTongue',
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            Text('Language: $language',
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            Text('Level: $level',
                style: const TextStyle(fontSize: 16, color: Colors.white)),
            const SizedBox(height: 20),
            ElevatedButton(
              child: const Text('Edit Profile'),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Column(
                      children: <Widget>[
                        TextFormField(
                          initialValue: username,
                          decoration:
                              const InputDecoration(labelText: 'Username'),
                          onChanged: (val) {
                            setState(() => username = val);
                          },
                          validator: (val) =>
                              val!.isEmpty ? 'Username cannot be empty' : null,
                        ),
                        TextFormField(
                          initialValue: motherTongue,
                          decoration:
                              const InputDecoration(labelText: 'Mother Tongue'),
                          onChanged: (val) {
                            setState(() => motherTongue = val);
                          },
                        ),
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Language you want to learn'),
                          value: language.isEmpty ? null : language,
                          onChanged: (val) {
                            setState(() => language = val ?? '');
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? 'Select the language you want to learn'
                              : null,
                          items: <String>['German', 'English']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        DropdownButtonFormField<String>(
                          decoration:
                              const InputDecoration(labelText: 'Your Level'),
                          value: level.isEmpty ? null : level,
                          onChanged: (val) {
                            setState(() => level = val ?? '');
                          },
                          validator: (val) => val == null || val.isEmpty
                              ? 'Select your level in the language you want to learn'
                              : null,
                          items: <String>['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        ElevatedButton(
                          child: const Text('Save'),
                          onPressed: () async {
                            String userId = _auth.currentUser?.uid ?? '';
                            await _user.updateUser(
                              userId,
                              username,
                              motherTongue,
                              language,
                              level,
                            );
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red[400],
              ),
              child: const Text('Delete Profile'),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Delete Profile'),
                      content: const Text(
                          'Are you sure you want to delete your profile? This action cannot be undone. All your data will be lost and you will be logged out.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Delete'),
                          onPressed: () async {
                            _deleteUser();
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 12.0),
            Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 14.0),
            )
          ],
        ),
      ),
    );
  }
}
