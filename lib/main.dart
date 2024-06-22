import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/screens/endpoints.dart';
import 'package:movielingo_app/screens/home.dart';
import 'package:movielingo_app/screens/profile.dart';
import 'package:movielingo_app/screens/user_information.dart';
import 'package:movielingo_app/screens/wrapper.dart';
import 'package:movielingo_app/services/auth.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: MaterialApp.router(
          title: 'MovieLingo',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyan,
              brightness: Brightness.dark,
            ),
          ),
          routerConfig: _router),
    );
  }
}

// Define the GoRouter
final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => const Wrapper(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const Home()),
    GoRoute(
        path: '/information',
        builder: (context, state) => const UserInformation()),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const Profile(),
    ),
    GoRoute(
      path: '/endpoints',
      builder: (context, state) => Endpoints(),
    ),
  ],
);
