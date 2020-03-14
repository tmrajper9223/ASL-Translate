import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'sign_up_page.dart';

class LoginPage extends StatefulWidget {
  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _emailFormKey = new GlobalKey<FormState>();
  final _passwordFormKey = new GlobalKey<FormState>();

  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool _requesting = false;

  // Display a Snackbar
  void _displaySnackbar(msg) {
    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text(msg),));
  }

  // Checks if Fields are Empty
  bool _verifyFields() {
    if (!_emailFormKey.currentState.validate() ||
        !_passwordFormKey.currentState.validate()) return false;
    return true;
  }

  // Submit Info to Firebase Auth
  Future<FirebaseUser> _submit() async {
    final email = _emailController.text.toString().trim();
    final password = _passwordController.text.toString().trim();
    try {
      final user = (await _auth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      return user;
    } catch (e) {
      setState(() {
        _requesting = false;
      });
      final invalidCredentials = "Invalid Email And/Or Password";
      final userDoesNotExist = "That Account Does Not Exists";
      final serverError = "Internal Server Error";
      if (e.code == "ERROR_INVALID_EMAIL" || e.code == "ERROR_WRONG_PASSWORD") {
        _displaySnackbar(invalidCredentials);
      } else if (e.code == "ERROR_USER_NOT_FOUND") {
        _displaySnackbar(userDoesNotExist);
      } else {
        _displaySnackbar(serverError);
      }
      print(e.message);
      return null;
    }
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

  // Build Button Widget
  Widget _buildButton() {
    return _buildContainer(RaisedButton(
      onPressed: () {
        if (!_verifyFields()) {
          Scaffold.of(context).showSnackBar(SnackBar(
            content: Text("Invalid Field(s)"),
          ));
        }
        setState(() {
          _requesting = true;
        });
        final user = _submit().then((_) {
          setState(() {
            _requesting = false;
          });
        });
        print("Good");
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
              children: <Widget>[
                title,
                email,
                password,
                loginButton,
                signUp
              ],
            ),
          ),
        ),
      ),
        inAsyncCall: _requesting,
    );
  }
}
