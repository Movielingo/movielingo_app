import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';
import 'package:movielingo_app/utils/validation_utils.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp({super.key, required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // text field state
  String email = '';
  String password = '';
  String motherTongue = '';
  String language = '';
  String level = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          title: const Text('Sign Up to MovieLingo'),
          actions: <Widget>[
            TextButton.icon(
              icon: const Icon(Icons.person),
              label: const Text('Sign In'),
              onPressed: () {
                widget.toggleView();
              },
            ),
          ]),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            key: _formKey,
            child: Column(children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Email*',
                    hintStyle: TextStyle(color: Colors.grey),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                  validator: (val) => val!.isEmpty ? 'Enter an email' : null,
                  style: const TextStyle(color: Colors.black),
                  onChanged: (val) {
                    setState(() => email = val);
                  }),
              const SizedBox(height: 20.0),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Password*',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                ),
                validator: (val) => ValidationUtils.validatePassword(val),
                style: const TextStyle(color: Colors.black),
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  hintText: 'Your Mother Tongue*',
                  hintStyle: TextStyle(color: Colors.grey),
                  fillColor: Colors.white,
                  filled: true,
                ),
                value: motherTongue.isEmpty ? null : motherTongue,
                onChanged: (val) => setState(() => motherTongue = val ?? ''),
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
                      AuthResult result =
                          await _auth.registerWithEmailAndPassword(
                              email, password, motherTongue, language, level);
                      if (result.user == null) {
                        setState(() => error = result.errorMessage ??
                            'An unexpected error occurred.');
                      }
                    }
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  )),
              const SizedBox(height: 12.0),
              Text(
                error,
                style: const TextStyle(color: Colors.red, fontSize: 14.0),
              )
            ]),
          )),
    );
  }
}
