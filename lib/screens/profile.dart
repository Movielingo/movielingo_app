import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/user_service.dart';
import 'package:movielingo_app/models/enums.dart';
import 'package:movielingo_app/utils/string_utils.dart';
import 'package:movielingo_app/utils/validation_utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final UserService _user = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // text field state
  late String motherTongue;
  late String language;
  late String level;
  late String error;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    motherTongue = '';
    language = '';
    level = CSRFLevel.values.first.name;
    error = '';
    _loadInitialData();
  }

  void _loadInitialData() async {
    String userId = _auth.currentUser!.uid;
    MyUserData? data = await _user.getUser(userId);
    setState(() {
      motherTongue = capitalizeFirstLetter(data.motherTongue!);
      language = capitalizeFirstLetter(data.language!);
      level = capitalizeFirstLetter(data.level!.name);
      isLoading = false;
    });
  }

// TODO: Implement the _deleteUser method
/*   void _deleteUser() async {
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
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(
              child: Text('Loading...',
                  style: TextStyle(fontSize: 20, color: Colors.white)))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Mother Tongue: $motherTongue',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Language: $language',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                  Text('Level: $level',
                      style:
                          const TextStyle(fontSize: 16, color: Colors.white)),
                  const SizedBox(height: 20),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 55.0,
                    child: ElevatedButton(
                      child: const Text('Edit Profile'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Form(
                              child: Column(
                                children: <Widget>[
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                        labelText: 'Mother Tongue'),
                                    value: motherTongue.isNotEmpty
                                        ? motherTongue
                                        : null,
                                    onChanged: (val) =>
                                        setState(() => motherTongue = val!),
                                    items: ValidationUtils.motherTongues
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                        labelText:
                                            'Language you want to learn'),
                                    value: language.isEmpty ? null : language,
                                    onChanged: (val) {
                                      setState(() => language = val ?? '');
                                    },
                                    validator: (val) => val == null ||
                                            val.isEmpty
                                        ? 'Select the language you want to learn'
                                        : null,
                                    items: <String>['German', 'English']
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                        labelText: 'Your Level'),
                                    value: level.isEmpty ? null : level,
                                    onChanged: (val) {
                                      setState(() => level = val ?? '');
                                    },
                                    validator: (val) => val == null ||
                                            val.isEmpty
                                        ? 'Select your level in the language you want to learn'
                                        : null,
                                    items: <String>[
                                      'A1',
                                      'A2',
                                      'B1',
                                      'B2',
                                      'C1',
                                      'C2'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                  ElevatedButton(
                                    child: const Text('Save'),
                                    onPressed: () async {
                                      String userId = _auth.currentUser!.uid;
                                      await _user.updateUser(userId,
                                          motherTongue, language, level, true);
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
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
