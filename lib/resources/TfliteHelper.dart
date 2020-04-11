import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

class TFLiteHelper {

  static Future<String> loadModel() async {
    return Tflite.loadModel(
      model: "assets/mobile-asl-model.tflite",
      labels: "assets/labels.txt"
    );
  }
  
  static classifyImage(path) async {
    return await Tflite.runModelOnImage(
      path: path,
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 1,
      threshold: 0.2,
      asynch: true
    ).then((value) {
      return value;
    });
  }

  /*
  static objDetection(path) async {
    return await Tflite.detectObjectOnImage(
      path: path,
      model: "SSDMobileNet",
      imageStd: 127.5,
      imageMean: 127.5,
      threshold: 0.4,
      numResultsPerClass: 2,
      asynch: true
    ).then((value) {
      return value;
    });
  }
   */

  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> saveImage(path) async {
    var newPath = await localPath;
    img.Image decodedImage = img.decodeImage(File(path).readAsBytesSync());
    img.Image resizedImage = img.copyResize(decodedImage, width: 64, height: 64);
    return new File('$newPath/image.jpg')..writeAsBytesSync(img.encodeJpg(resizedImage));
  }

}