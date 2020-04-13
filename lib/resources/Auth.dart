import 'package:firebase_auth/firebase_auth.dart';

import 'package:asltranslate/resources/DataPersistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class for Register/login methods
abstract class Auth {
  Future<FirebaseUser> signIn(String email, String password);

  Future<FirebaseUser> signUp(String email, String password);

  Future<bool> signOut();
}

class Authentication implements Auth {
  FirebaseAuth _auth = FirebaseAuth.instance;

  String _errorCode;

  // Signs user in, handles errors
  @override
  Future<FirebaseUser> signIn(String email, String password) async {
    try {
      final user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      await DataPersistence().setLoginPersistence(true);
      return user;
    } catch (e) {
      _errorCode = e.message;
      return null;
    }
  }

  // Signs Up user, handles errors
  @override
  Future<FirebaseUser> signUp(String email, String password) async {
    try {
      final FirebaseUser newUser = (await _auth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user;
      return newUser;
    } catch (e) {
      _errorCode = e.message;
      return null;
    }
  }

  @override
  Future<bool> signOut() async {
    try {
      await DataPersistence().setLoginPersistence(false);
      return await _auth.signOut().then((val) {
        return true;
      });
    } catch (e) {
      return new Future<bool>(() {
        return false;
      });
    }
  }

  // Returns Firebase error message to display to user
  String getErrorCode() {
    return _errorCode;
  }
}
