import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('MovieLingo'),
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.settings),
            label: const Text('Profile'),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
