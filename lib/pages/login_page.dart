import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up_page.dart';
import 'camera_page.dart';
import 'package:asltranslate/resources/Auth.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailFormKey = new GlobalKey<FormState>();
  final _passwordFormKey = new GlobalKey<FormState>();

  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  final _authentication = new Authentication();

  bool _requesting = false;
  bool _loginSuccessful = true;

  // Display a SnackBar
  void _displaySnackBar(msg) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      duration: const Duration(
        seconds: 3
      ),
    ));
  }

  // Checks if Fields are Empty
  bool _verifyFields() {
    var emailState = _emailFormKey.currentState.validate();
    var passState = _passwordFormKey.currentState.validate();
    if (emailState == false || passState == false) return false;
    return true;
  }

  // Create New Camera Page
  Route _createCameraPageRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => CameraPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
          Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  // Create New Sign Up Page
  Route _createSignUpRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => SignUpPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(0.0, 1.0);
          var end = Offset.zero;
          var curve = Curves.ease;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        });
  }

  // Returns Title Widget
  Widget _buildTitle() {
    return _buildContainer(Text(
      "Sign Language Translator",
      style: TextStyle(fontSize: 25),
    ));
  }

  // Creates Email Text Field Form
  Widget _buildEmailField(hint) {
    return _buildContainer(Form(
      key: _emailFormKey,
      child: TextFormField(
        controller: _emailController,
        validator: (value) {
          if (value.isEmpty) return "Field Cannot Be Empty!";
          if (_loginSuccessful == false) return _authentication.getErrorCode();
          return null;
        },
        decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0))),
      ),
    ));
  }

  // Creates Password Text Field Form
  Widget _buildPasswordField(hint) {
    return _buildContainer(Form(
      key: _passwordFormKey,
      child: TextFormField(
        controller: _passwordController,
        validator: (value) {
          if (value.isEmpty) return "Field Cannot Be Empty!";
          if (_loginSuccessful == false) return "Password Invalid or Account Does Not Exist!";
          return null;
        },
        obscureText: true,
        decoration: InputDecoration(
            hintText: hint,
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
                borderSide: BorderSide(color: Colors.blueAccent, width: 2.0))),
      ),
    ));
  }

  // Submit Info to Firebase Auth
  Future<FirebaseUser> _submit() async {
    var email = _emailController.text.trim();
    var password = _passwordController.text.trim();
    setState(() {
      _requesting = true;
    });
    return _authentication.signIn(email, password);
  }

  // On Login Button Pressed
  void _onPressed() {
    if (!_verifyFields()) {
      _displaySnackBar("Field(s) Cannot Be Empty!");
      return;
    }
    _submit().then((value) {
      setState(() {
        if (value == null) {
          _loginSuccessful = false;
          if (_authentication.getErrorCode().toLowerCase().contains("email"))  _emailFormKey.currentState.validate();
          else if (_authentication.getErrorCode().toLowerCase().contains("identifier")) _passwordFormKey.currentState.validate();
          _loginSuccessful = true;
          _displaySnackBar(_authentication.getErrorCode());
        } else {
          _loginSuccessful = true;
          Navigator.of(context).push(_createCameraPageRoute());
        }
      });
      setState(() {
        _requesting = false;
      });
    });
  }

  // Build Button Widget
  Widget _buildButton() {
    return _buildContainer(RaisedButton(
      onPressed: () {
        _onPressed();
      },
      color: Colors.blueAccent,
      textColor: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: const Text(
          "Login",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    ));
  }

  // Build the Sign Up Link Text
  Widget _buildSignUpLink() {
    return _buildContainer(GestureDetector(
      child: Text(
        "Don't have an Account? Sign Up Here",
        style: TextStyle(
          fontSize: 15,
          decoration: TextDecoration.underline,
          decorationThickness: 2.0,
          decorationColor: Colors.blue,
          color: Colors.blue,
        ),
      ),
      onTap: () {
        print("Sign Up Text Clicked");
        Navigator.of(context).push(_createSignUpRoute());
      },
    ));
  }

  // Creates Container with widget parameter as child
  Widget _buildContainer(widget) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = _buildTitle();
    final loginButton = _buildButton();
    final signUp = _buildSignUpLink();
    final email = _buildEmailField("Your Email");
    final password = _buildPasswordField("Your Password");

    return ModalProgressHUD(
      child: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[title, email, password, loginButton, signUp],
            ),
          ),
        ),
      ),
      inAsyncCall: _requesting,
    );
  }
}
