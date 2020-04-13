import 'package:shared_preferences/shared_preferences.dart';

class DataPersistence {

  Future<void> setLoginPersistence(bool isLoggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("isLoggedIn", isLoggedIn);
  }

  Future<bool> checkIfLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool("isLoggedIn");
    if (isLoggedIn == null) return false;
    return isLoggedIn;
  }

}