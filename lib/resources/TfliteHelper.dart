import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';

class TFLiteHelper {

  var _counter = 0;

  static Future<String> loadModel() async {
    return Tflite.loadModel(
      model: "assets/mobile-asl-model-v1.0.1.tflite",
      labels: "assets/labels.txt"
    );
  }
  
  static classifyImage(path) async {
    return await Tflite.runModelOnImage(
      path: path,
      imageMean: 255.0,
      imageStd: 255.0,
      asynch: true
    ).then((value) {
      print(value);
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

  Future<String> saveImage(path) async {
    var nameCounter = _counter;
    var newPath = await localPath;
    img.Image decodedImage = img.decodeImage(File(path).readAsBytesSync());
    img.Image resizedImage = img.copyResize(decodedImage, width: 224, height: 224);
    new File('$newPath/image_$nameCounter.jpg')..writeAsBytesSync(img.encodeJpg(resizedImage));
    _counter++;
    return "$newPath/image_$nameCounter.jpg";
  }

}