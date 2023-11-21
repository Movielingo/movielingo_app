import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/user.dart';

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
    loadInitialData();
  }

  void loadInitialData() async {
    String userId = _auth.currentUser?.uid ?? '';
    MyUserData? data = await _user.getUser(userId);
    setState(() {
      username = data.username ?? '';
      motherTongue = data.motherTongue ?? '';
      language = data.language ?? '';
      level = data.level ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(185, 246, 202, 1),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.greenAccent,
        elevation: 0.0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Username: $username', style: const TextStyle(fontSize: 16)),
            Text('Mother Tongue: $motherTongue',
                style: const TextStyle(fontSize: 16)),
            Text('Language: $language', style: const TextStyle(fontSize: 16)),
            Text('Level: $level', style: const TextStyle(fontSize: 16)),
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
                        const SizedBox(height: 12.0),
                        Text(
                          error,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 14.0),
                        )
                      ],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
