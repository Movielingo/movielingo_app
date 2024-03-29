import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/screens/endpoints/endpoints.dart';
import 'package:movielingo_app/screens/profile/profile.dart';
import 'package:movielingo_app/screens/wrapper.dart';
import 'package:movielingo_app/services/auth.dart';
import 'package:movielingo_app/singletons/logger.dart';
import 'package:provider/provider.dart';

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
      child: MaterialApp(
          title: 'MovieLingo',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyan,
              brightness: Brightness.dark,
            ),
          ),
          home: const Wrapper(),
          routes: {
            '/profile': (context) => const Profile(),
            '/endpoints': (context) => Endpoints(),
          }),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void onButtonPush() {
    LoggerSingleton().logger.i('button push');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
                onPressed: onButtonPush, child: const Text('get all movies'))
          ],
        ),
      ),
    );
  }
}
