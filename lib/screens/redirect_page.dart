import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:movielingo_app/screens/authenticate/authenticate.dart';
import 'package:movielingo_app/screens/home.dart';

class RedirectPage extends StatelessWidget {
  const RedirectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return const Home();
          } else {
            return const Authenticate();
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
