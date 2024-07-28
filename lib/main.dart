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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // TODO: Add FirebaseAppCheck activation code here!
  await FirebaseAppCheck.instance.activate(
    // Default provider for Android is the Play Integrity provider. You can use the "AndroidProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Safety Net provider
    // 3. Play Integrity provider
    androidProvider: AndroidProvider.debug,
    // Default provider for iOS/macOS is the Device Check provider. You can use the "AppleProvider" enum to choose
    // your preferred provider. Choose from:
    // 1. Debug provider
    // 2. Device Check provider
    // 3. App Attest provider
    // 4. App Attest provider with fallback to Device Check provider (App Attest provider is only available on iOS 14.0+, macOS 14.0+)
    appleProvider: AppleProvider.appAttest,
  );

  Get.put(FirebaseStorageService());
  Get.put(VocabularyBoxController());

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
