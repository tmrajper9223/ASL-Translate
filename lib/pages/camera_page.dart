import 'package:flutter/material.dart';

import 'alphabet_index_page.dart';

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

  final _pageController = PageController(
    initialPage: 0,
  );

  @override
  Widget build(BuildContext context) {
    return  Center(
      child: Text("Hello From Camera"),
    );
  }
}