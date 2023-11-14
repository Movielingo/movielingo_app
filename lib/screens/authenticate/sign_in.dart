import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
        title: const Text('Sign in to MovieLingo'),
      ),
      body: Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
          child: Form(
            child: Column(children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    // setState(() => email = val);
                  }),
              const SizedBox(height: 20.0),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (val) {
                  // setState(() => password = val);
                },
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  onPressed: () async {
                    // print(email);
                    // print(password);
                  },
                  child: const Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  )),
            ]),
          )),
    );
  }
}
