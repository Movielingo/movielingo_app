import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/screens/authenticate/authenticate.dart';
import 'package:movielingo_app/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    print(user);

    // return either Home or Authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return Home();
    }
  }
}
