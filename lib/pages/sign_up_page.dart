import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:asltranslate/resources/Auth.dart';
import 'package:asltranslate/resources/User.dart';
import 'package:asltranslate/resources/firestore.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Center(
        child: SignUp(),
      ),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  SignUpPageState createState() => SignUpPageState();
}

class SignUpPageState extends State<SignUp> {
  final _nameController = new TextEditingController();
  final _emailController = new TextEditingController();
  final _passwordController = new TextEditingController();
  final _cPasswordController = new TextEditingController();

  final _nameFormKey = GlobalKey<FormState>();
  final _emailFormKey = GlobalKey<FormState>();
  final _passFormKey = GlobalKey<FormState>();
  final _cPassFormKey = GlobalKey<FormState>();

  final _authentication = new Authentication();

  bool _saving = false;
  bool _isSuccessful = true;

  // Returns Container with Title Widget
  Widget _buildTitle() {
    final text = "Sign Up";
    final title = Text(
      text,
      style: TextStyle(fontSize: 50),
    );
    return _buildContainer(title);
  }

  // Returns Container with Back Text Link
  Widget _backTextLink() {
    final backText = "Back";
    final back = GestureDetector(
      child: Text(
        backText,
        style: TextStyle(
          fontSize: 20,
          decoration: TextDecoration.underline,
          decorationThickness: 2.0,
          decorationColor: Colors.blue,
          color: Colors.blue,
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
    return _buildContainer(back);
  }

  // Returns Container with Form Field for Name
  Widget _nameFieldBuilder(hint) {
    return _buildContainer(Form(
        key: _nameFormKey,
        child: TextFormField(
          controller: _nameController,
          validator: (value) {
            if (value.isEmpty) return "Field Cannot Be Blank";

            final name = _nameController.text.trim();
            if (name.split(" ").length != 2) return "Please Enter your First and Last Name!";

            return null;
          },
          decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.blueAccent, width: 2.0))),
        )));
  }

  // Builds Container with Form field for Email
  Widget _emailFieldBuilder(hint) {
    return _buildContainer(Form(
        key: _emailFormKey,
        child: TextFormField(
          controller: _emailController,
          validator: (value) {
            if (value.isEmpty)
              return "Field Cannot Be Blank";
            else if (_isSuccessful == false)
              return _authentication.getErrorCode();
            return null;
          },
          decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.blueAccent, width: 2.0))),
        )));
  }

  // Builds Container with Form field for both Password and Confirm Password
  Widget _passwordFieldBuilder(hint) {
    return _buildContainer(Form(
        key: _passFormKey,
        child: TextFormField(
          controller: _passwordController,
          validator: (value) {
            if (value.isEmpty)
              return "Field Cannot Be Blank";
            else if (_isSuccessful == false)
              return "Password Must Be At Least 6 Characters";
            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.blueAccent, width: 2.0))),
        )));
  }

  // Builds Container with Form field for both Password and Confirm Password
  Widget _confirmPasswordField(hint) {
    return _buildContainer(Form(
        key: _cPassFormKey,
        child: TextFormField(
          controller: _cPasswordController,
          validator: (value) {
            var password = _passwordController.text.toString().trim();
            var confirmPassword = _cPasswordController.text.toString().trim();

            if (value.isEmpty)
              return "Field Cannot Be Blank";
            else if (password != confirmPassword)
              return "Passwords Must Match";
            else if (_isSuccessful == false)
              return "Password Must Be At Least 6 Characters";

            return null;
          },
          obscureText: true,
          decoration: InputDecoration(
              hintText: hint,
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide:
                      BorderSide(color: Colors.blueAccent, width: 2.0))),
        )));
  }

  // Return Container with field as child
  Widget _buildContainer(field) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: field,
    );
  }

  // Verifies Input is not Null or Empty, or Incorrect Input
  bool _verifyInput() {
    var keys = {_nameFormKey, _emailFormKey, _passFormKey, _cPassFormKey};
    for (GlobalKey<FormState> key in keys) {
      if (!key.currentState.validate()) {
        return false;
      }
    }
    return true;
  }

  // Verify Passwords Match
  bool _doPasswordsMatch() {
    if (!_cPassFormKey.currentState.validate()) return false;
    return true;
  }

  // Display SnackBar
  void _displaySnackBar(msg) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // Submits New User to Firebase
  Future<FirebaseUser> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    _displaySnackBar("Creating Your Account...");
    setState(() {
      _saving = true;
    });
    return _authentication.signUp(email, password);
  }

  // Add New User to FireStore
  void _addNewUser() {
    final String name = _nameController.text.trim();
    final String email = _emailController.text.trim();
    User newUser = new User(name, email);
    FireStore fireStore = new FireStore();
    fireStore.addNewUser(newUser).then((_) {
      setState(() {
        _isSuccessful = true;
      });
      Scaffold.of(context).hideCurrentSnackBar();
      _displaySnackBar("Account Created!");
    });
  }

  // Handles SignUp Button onClick Event
  void _onPressed() {
    if (!_verifyInput()) return;
    if (!_doPasswordsMatch()) return;
    _submit().then((value) => {
          setState(() {
            _saving = false;
            if (value == null) {
              _isSuccessful = false;
              final code = _authentication.getErrorCode().toLowerCase();
              if (code.contains("email") && code.contains("password")) {
                _emailFormKey.currentState.validate();
                _passFormKey.currentState.validate();
                _cPassFormKey.currentState.validate();
              } else if (code.contains("email")) {
                _emailFormKey.currentState.validate();
              } else if (code.contains("password")) {
                _passFormKey.currentState.validate();
                _cPassFormKey.currentState.validate();
              }
              Scaffold.of(context).hideCurrentSnackBar();
              _displaySnackBar("Failed to Create Account");
              _isSuccessful = true;
            } else {
              _addNewUser();
            }
          })
        });
  }

  // Returns Container with Button Widget
  Widget _buildSubmitButton() {
    final button = RaisedButton(
      onPressed: () {
        _onPressed();
      },
      color: Colors.blueAccent,
      textColor: Colors.white,
      padding: const EdgeInsets.all(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: const Text(
          "Sign Up",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
    return _buildContainer(button);
  }

  @override
  Widget build(BuildContext context) {
    final title = _buildTitle();
    final name = _nameFieldBuilder("First and Last Name");
    final email = _emailFieldBuilder("Email Address");
    final password = _passwordFieldBuilder("New Password");
    final cPassword = _confirmPasswordField("Confirm Password");
    final submitButton = _buildSubmitButton();
    final back = _backTextLink();

    return ModalProgressHUD(
      child: Center(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                title,
                name,
                email,
                password,
                cPassword,
                submitButton,
                back
              ],
            ),
          ),
        ),
      ),
      inAsyncCall: _saving,
    );
  }
}
