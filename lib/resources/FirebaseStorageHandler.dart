import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageHandler {

  final FirebaseStorage storage = FirebaseStorage(storageBucket: "gs://asl-translate-f03b2.appspot.com");

  Future<String> retrieveImage(String character) async {
    final String fileName = character + "_test.jpg";
    final ref = FirebaseStorage.instance.ref().child(fileName);
    var url = await ref.getDownloadURL();
    return url;
  }

}