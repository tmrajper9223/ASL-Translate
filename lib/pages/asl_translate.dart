import 'package:flutter/material.dart';

import 'login_page.dart';

class ASLTranslate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "ASL Translator",
      home: Scaffold(
        appBar: AppBar(
          title: Text("ASL Translate")
        ),
        body: Center(
          child: LoginPage()
        ),
      )
    );
  }

}