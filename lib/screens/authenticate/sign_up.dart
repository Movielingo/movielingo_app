import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;

  const SignUp({Key? key, required this.toggleView}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  // text field state
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.greenAccent[400],
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
            child: Column(children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                  style: const TextStyle(color: Colors.white),
                  onChanged: (val) {
                    setState(() => email = val);
                  }),
              const SizedBox(height: 20.0),
              TextFormField(
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
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
                    print(email);
                    print(password);
                  },
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  )),
            ]),
          )),
    );
  }
}
