import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movielingo_app/controllers/vocabulary_box_controller.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/screens/endpoints.dart';
import 'package:movielingo_app/screens/home.dart';
import 'package:movielingo_app/screens/vocabulary_box.dart';
import 'package:movielingo_app/screens/profile.dart';
import 'package:movielingo_app/screens/user_information.dart';
import 'package:movielingo_app/services/auth_service.dart';
import 'package:movielingo_app/services/firebase_storage_service.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'screens/redirect_page.dart';
import 'firebase_options.dart';
import 'controllers/app_lifecycle_controller.dart';
import 'observers/app_lifecycle_observer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
    appleProvider: AppleProvider.appAttest,
  );

  Get.put(FirebaseStorageService());
  Get.put(VocabularyBoxController());
  Get.put(AppLifecycleController());

  WidgetsBinding.instance.addObserver(AppLifecycleObserver());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamProvider<MyUser?>.value(
      initialData: null,
      value: AuthService().user,
      child: GetMaterialApp(
          title: 'MovieLingo',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyan,
              brightness: Brightness.dark,
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey;
                    }
                    return Colors.cyan;
                  },
                ),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                foregroundColor: MaterialStateProperty.resolveWith(
                  (states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.grey[600];
                    }
                    return Colors.white;
                  },
                ),
              ),
            ),
          ),
          initialRoute: '/',
          getPages: [
            GetPage(name: '/', page: () => const RedirectPage()),
            GetPage(name: '/information', page: () => const UserInformation()),
            GetPage(name: '/home', page: () => const Home()),
            GetPage(name: '/box', page: () => const VocabularyBox()),
            GetPage(name: '/profile', page: () => const Profile()),
            GetPage(name: '/endpoints', page: () => Endpoints()),
          ]),
    );
  }
}
