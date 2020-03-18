import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'package:asltranslate/resources/Camera.dart';
import 'package:asltranslate/resources/Camera.dart';

class CameraPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Camera")),
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
  final cameras = InitCamera.cameras;

  CameraController controller;
  bool _isInitialized = true;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) return;
      setState(() {
        _isInitialized = false;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  IconData _cameraLensIcon(lensDirection) {
    switch(lensDirection) {
      case CameraLensDirection.back:
        return Icons.camera_rear;
        break;
      case CameraLensDirection.front:
        return Icons.camera_front;
        break;
      case CameraLensDirection.external:
        return Icons.camera;
        break;
      default:
        return Icons.device_unknown;
        break;
    }
  }

  Widget _toggleCameraWidget() {
    if (InitCamera.cameras == null) return Row();
    CameraDescription selectedCamera = InitCamera.cameras[0];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;

    return Expanded(
      child: Align(
       alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: () {
              print("Toggle Clicked");
            },
            icon: Icon(_cameraLensIcon(lensDirection)),
            label: Text("${lensDirection.toString().substring(lensDirection.toString().indexOf('.')+1)}")
        ),
      ),
    );
  }

  Widget _captureWidget() {
    return Expanded(
      child: Align(
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.camera_alt),
              color: Colors.blue,
              onPressed: () {
                (controller != null) && (controller.value.isInitialized) ? print("Captured") : print("Failed");
              },
            )
          ],
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
            child: Padding(
              padding: const EdgeInsets.only(top: 1.0),
              child: Center(
                  child: AspectRatio(
                    aspectRatio: controller.value.aspectRatio,
                    child: CameraPreview(controller),
                  ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _toggleCameraWidget(),
              _captureWidget()
            ],
          ),
        )
      ],
    );
  }
}
