import 'dart:io';
import 'package:asltranslate/resources/TfliteHelper.dart';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CameraPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      drawer: Drawer(
        
      ),
      body: Center(
        child: Camera(),
      ),
    );
  }
}

class Camera extends StatefulWidget {
  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<Camera> {

  CameraController controller;
  List cameras;
  int selectedCameraId;

  bool modelLoaded = false;

  @override
  void initState() {
    super.initState();
    availableCameras().then((availableCameras) {
      cameras = availableCameras;
      if (cameras.length > 0) {
        setState(() {
          selectedCameraId = 0;
        });
        _initCameraController(cameras[selectedCameraId]).then((void v) {});
      } else {
        print("No Camera Available");
      }
    }).catchError((err) {
      print('Error: $err.code\nError Message: $err.message');
    });

    TFLiteHelper.loadModel().then((value) {
      setState(() {
        modelLoaded = true;
      });
    });
  }

  Future<void> _buildAlertDialog(context, path, prediction) {
    final label = prediction[0]["label"];
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              height: 600,
              width: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "Prediction: $label",
                      style: TextStyle(
                          fontSize: 25.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Image.file(
                        File(path),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "Done",
                      style: TextStyle(fontSize: 20.0),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.medium);
    controller.addListener(() {
      if (mounted)
        setState(() {});
      if (controller.value.hasError) print(
          "Camera error ${controller.value.errorDescription}");
    });
    try {
      await controller.initialize();
    } on CameraException catch (e) {
      // _showCameraException(e);
    }
    if (mounted)
      setState(() {});
  }

  void _onCapture(context) async {
    try {
      final imageName = DateTime.now();
      final path = join(
          (await getTemporaryDirectory()).path,
          "$imageName.jpg"
      );
      await controller.takePicture(path);
      final prediction = await TFLiteHelper.classifyImage(path);
      _buildAlertDialog(context, path, prediction);
    } catch (e) {
      print(e);
    }
  }

  Widget _cameraFeedWidget(BuildContext context) {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        "Loading",
        style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.w900
        ),
      );
    }

    final size = MediaQuery.of(context).size;
    final deviceRatio = (size.width / size.height);


    return new Transform.scale(
      scale: controller.value.aspectRatio/deviceRatio,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: Container(
          child: Stack(
            children: <Widget>[
              new CameraPreview(controller),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  height: 120.0,
                  padding: EdgeInsets.all(0.0),
                  child: Stack(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.center,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(50.0)),
                            onTap: () {
                              _onCapture(context);
                            },
                            child: Container(
                              padding: EdgeInsets.all(0.0),
                              child: Icon(
                                Icons.camera,
                                color: Colors.white,
                                size: 60.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
              child: _cameraFeedWidget(context)
          ),
        ),
      ],
    );
  }
}

