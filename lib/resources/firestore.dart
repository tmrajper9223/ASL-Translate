import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:asltranslate/resources/User.dart';

abstract class FireStoreOperations {
  Future<void> addNewUser(User newUser);
}

class FireStore extends FireStoreOperations {

  final db = Firestore.instance;

  @override
  Future<void> addNewUser(User newUser) async {
    final fullName = newUser.getBaseUsername().split(" ");
    final userEmail = newUser.getBaseUserEmail();
    final DocumentReference ref = await db.collection("users")
      .add({
        'firstName': fullName[0],
        'lastName': fullName[1],
        'email': userEmail
      });
    print(ref.documentID);
  }

}