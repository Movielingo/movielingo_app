import 'package:firebase_auth/firebase_auth.dart';
import 'package:movielingo_app/models/myuser.dart';
import 'package:movielingo_app/services/user_service.dart';
import 'package:movielingo_app/singletons/logger.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Define a custom result type
class AuthResult {
  final MyUser? user;
  final String? errorMessage;

  AuthResult({this.user, this.errorMessage});
}

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  static final AuthService _singleton = AuthService._internal();

  factory AuthService() {
    return _singleton;
  }

  AuthService._internal();

  // create user obj based on FirebaseUser
  MyUser? _userfromFirebase(User? user) {
    return user != null
        ? MyUser(uid: user.uid, isProfileComplete: false)
        : null;
  }

  // auth change user stream that returns back a user whenever there is a
  // change in authentication
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map(_userfromFirebase);
  }

  // sign in anonymous
  Future signInAnon() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userfromFirebase(user!);
    } catch (e) {
      LoggerSingleton().logger.e(e.toString());
      return null;
    }
  }

  // sign in with email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User? user = result.user;
      return _userfromFirebase(user!);
    } catch (e) {
      LoggerSingleton().logger.e(e.toString());
      return null;
    }
  }

  // register with email & password
  Future<AuthResult> registerWithEmailAndPassword(String email, String password,
      String motherTongue, String language, String level) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      User? user = result.user;

      // create a new document for the user with the uid
      await UserService().addUser(
          user!.uid, user.email!, motherTongue, language, level, false);

      return AuthResult(user: _userfromFirebase(user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        LoggerSingleton().logger.e('The password provided is too weak.');
        return AuthResult(errorMessage: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        LoggerSingleton()
            .logger
            .e('The account already exists for that email.');
        return AuthResult(
            errorMessage: 'The account already exists for that email.');
      }
      return AuthResult(errorMessage: e.message);
    } catch (e) {
      LoggerSingleton().logger.e(e.toString());
      return AuthResult(errorMessage: 'An unexpected error occurred.');
    }
  }

  // sign in with Google
  Future<AuthResult> signInWithGoogle() async {
    try {
      // begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      // create a new credential for the user
      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      // sign in with the credential
      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // check if user exists in Firestore
      final userService = UserService();
      final userExists = await userService.checkUserExists(user!.uid);

      if (!userExists) {
        // create a new document for the user with the uid if it doesn't exist
        await userService.addUser(
            user.uid, user.email!, 'german', 'english', 'b1', false);
      }

      return AuthResult(user: _userfromFirebase(user));
    } catch (e) {
      LoggerSingleton().logger.e(e.toString());
      return AuthResult(
          errorMessage: 'An error occurred during Google sign-in.');
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      LoggerSingleton().logger.e(e.toString());
      return null;
    }
  }
}
