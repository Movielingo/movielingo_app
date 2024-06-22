import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
              // TODO: add confirm password field here
              const SizedBox(height: 20.0),
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
                              email, password, 'german', 'english', 'b1');
                      if (result.user == null) {
                        setState(() => error = result.errorMessage ??
                            'An unexpected error occurred.');
                      } else {
                        // Navigate after the async operation completes
                        if (!mounted) return;
                        context.go('/');
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
