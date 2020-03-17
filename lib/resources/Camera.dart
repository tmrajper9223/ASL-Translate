import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class InitCamera {

  static List<CameraDescription> cameras;

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    cameras = await availableCameras();
  }

  List<CameraDescription> getCameras() {
    return cameras;
  }

}