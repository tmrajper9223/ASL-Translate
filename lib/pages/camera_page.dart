import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

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

  CameraController controller;
  List cameras;
  int selectedCameraId;

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
  }

  Future _initCameraController(CameraDescription cameraDescription) async {
    if (controller != null) await controller.dispose();
    controller = CameraController(cameraDescription, ResolutionPreset.medium);
    controller.addListener(() {
      if (mounted)
        setState(() {});
      if (controller.value.hasError) print("Camera error ${controller.value.errorDescription}");
    });
    try {
      await controller.initialize();
    } on CameraException catch (e) {
     // _showCameraException(e);
    }
    if (mounted)
      setState(() {});
  }

  IconData _getCameraIcon(CameraLensDirection lensDirection) {
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

  void _onSwitchCamera() {
    selectedCameraId = (selectedCameraId < cameras.length-1) ? selectedCameraId+1 : 0;
    CameraDescription selectedCamera = cameras[selectedCameraId];
    _initCameraController(selectedCamera);
  }

  Widget _toggleCameraWidget() {
    if (cameras == null || cameras.isEmpty) return Spacer();
    CameraDescription selectedCamera = cameras[selectedCameraId];
    CameraLensDirection lensDirection = selectedCamera.lensDirection;
    return Expanded(
      child: Align(
        alignment: Alignment.centerLeft,
        child: FlatButton.icon(
            onPressed: () {
              _onSwitchCamera();
            },
            icon: Icon(_getCameraIcon(lensDirection)),
            label: Text(
                "${lensDirection.toString().substring(lensDirection.toString().indexOf('.') + 1)}"
            )
        ),
      ),
    );
  }

  void _onCapture(context) async {
    try {
      final path = join(
          (await getTemporaryDirectory()).path,
        "${DateTime.now()}"
      );
      await controller.takePicture(path);
    }
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

  Widget _cameraPreviewWidget() {
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
    return AspectRatio(
      aspectRatio: controller.value.aspectRatio,
      child: CameraPreview(controller),
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
                child: _cameraPreviewWidget()
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
             // _toggleCameraWidget(), Camera Preview for Front Camera not Adjusting to Lighting
              _captureWidget()
            ],
          ),
        )
      ],
    );
  }
}

