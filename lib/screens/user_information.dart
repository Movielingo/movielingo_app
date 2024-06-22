import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/enums.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/user_service.dart';
import 'package:movielingo_app/utils/string_utils.dart';
import 'package:movielingo_app/utils/validation_utils.dart';
import 'package:go_router/go_router.dart';

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
  final UserService _user = UserService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: const Text('User Information'),
      ),
      body: isLoading
          ? const Center(
              child: Text('Loading...',
                  style: TextStyle(fontSize: 20, color: Colors.white)))
          : Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(children: <Widget>[
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: 'Your Mother Tongue*',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                    ),
                    value: motherTongue.isEmpty ? null : motherTongue,
                    onChanged: (val) =>
                        setState(() => motherTongue = val ?? ''),
                    validator: (val) => val == null || val.isEmpty
                        ? 'Select your mother tongue'
                        : null,
                    items: ValidationUtils.motherTongues
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: 'Language you want to learn*',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                    ),
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
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      hintText: 'Your Level*',
                      hintStyle: TextStyle(color: Colors.grey),
                      fillColor: Colors.white,
                      filled: true,
                    ),
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
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Handle form submission or navigation here
                        String userId = _auth.currentUser!.uid;
                        await _user.updateUser(
                            userId, motherTongue, language, level, true);
                        // ignore: use_build_context_synchronously
                        context.go('/home');
                      }
                    },
                    child: const Text(
                      'Save Information',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14.0),
                  ),
                ]),
              ),
            ),
    );
  }
}
