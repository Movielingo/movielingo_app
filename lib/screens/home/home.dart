import 'package:flutter/material.dart';
import 'package:movielingo_app/services/auth.dart';
import '../../services/user_service.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final AuthService _auth = AuthService();
  final UserService userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MovieLingo'),
        backgroundColor: Colors.greenAccent[400],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.person),
            label: const Text('Profile'),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.settings),
            label: const Text('Endpoints'),
            onPressed: () {
              Navigator.pushNamed(context, '/endpoints');
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Welcome to MovieLingo',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
