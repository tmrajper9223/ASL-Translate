import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:path/path.dart';

class TFLiteHelper {

  static Future<String> loadModel() async {
    return Tflite.loadModel(
      model: "assets/mobile-asl-model.tflite",
      labels: "assets/labels.txt"
    );
  }
  
  static classifyImage(path) async {
    var recognitions = await Tflite.runModelOnImage(
      path: path,
    ).then((value) {
      print("Prediction: ");
      print(value);
    });
  }

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