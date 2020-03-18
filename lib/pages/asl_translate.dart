import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'login_page.dart';

class ASLTranslate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
      SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown
      ]);
    return MaterialApp(
      title: "ASL Translator",
      home: Scaffold(
        appBar: AppBar(
          title: Text("ASL Translate")
        ),
        body: LoginPage(),
        resizeToAvoidBottomPadding: true,
      )
    );
  }

}