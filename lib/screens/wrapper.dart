import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/screens/authenticate/authenticate.dart';
import 'package:movielingo_app/screens/home.dart';
import 'package:movielingo_app/screens/user_information.dart';
import 'package:movielingo_app/singletons/logger.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<MyUser?>(context);
    LoggerSingleton().logger.i(user);

    if (user == null) {
      return const Authenticate();
    } else if (!user.isProfileComplete) {
      return const UserInformation();
    } else {
      return const Home();
    }
  }
}
