import 'package:flutter/material.dart';

import 'package:asltranslate/pages/asl_translate.dart';
import 'resources/Camera.dart';

void main() async {
  await InitCamera().initCamera();
  runApp(ASLTranslate());
}
