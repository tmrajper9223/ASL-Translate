import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:asltranslate/resources/User.dart';

abstract class FireStoreOperations {
  Future<void> addNewUser(User newUser);

  Future<void> retrieveUserInfo();
}

class FireStore extends FireStoreOperations {

  final db = Firestore.instance;
  final _auth = FirebaseAuth.instance;

  @override
  Future<void> addNewUser(User newUser) async {
    final userId = await _auth.currentUser().then((val) {
      return val.uid;
    });
    final fullName = newUser.getBaseUsername().split(" ");
    final userEmail = newUser.getBaseUserEmail();
    await db.collection("users").
      document(userId).
      setData({
        'firstName': fullName[0],
        'lastName': fullName[1],
        'email': userEmail,
        'userId': userId
      });
  }

  @override
  Future<Map<String, dynamic>> retrieveUserInfo() async {
    final userId = await _auth.currentUser().then((val) {
      return val.uid;
    });
    return await db.collection("users").document(userId).get().then((val) {
      return val.data;
    });
  }

}