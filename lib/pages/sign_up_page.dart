import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpPage extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
                appBar: AppBar(
                    title: Text("Sign Up")
                ),
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

    final FirebaseAuth _auth = FirebaseAuth.instance;

    bool _saving = false;

    // Returns Container with Title Widget
    Widget _buildTitle() {
        final text = "Sign Up";
        final title = Text(
            text,
            style: TextStyle(
                fontSize: 50
            ),
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
            onTap: ()
            {
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
                    validator: (value)
                    {
                        if (value.isEmpty) {
                            return "Field Cannot Be Blank";
                        }
                        return null;
                    },
                    decoration: InputDecoration(
                        hintText: hint,
                        contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0),
                            borderSide: BorderSide(
                                color: Colors.blueAccent, width: 2.0
                            )
                        )
                    ),
                )
            )
        );
    }

    // Builds Container with Form field for Email
    Widget _emailFieldBuilder(hint) {
        return _buildContainer(Form(
            key: _emailFormKey,
            child: TextFormField(
                controller: _emailController,
                validator: (value)
                {
                    if (value.isEmpty) {
                        return "Field Cannot Be Blank";
                    }
                    return null;
                },
                decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                            color: Colors.blueAccent, width: 2.0
                        )
                    )
                ),
            )
        )
        );
    }

    // Builds Container with Form field for both Password and Confirm Password
    Widget _passwordFieldBuilder(hint) {
        return _buildContainer(Form(
            key: _passFormKey,
            child: TextFormField(
                controller: _passwordController,
                validator: (value)
                {
                    if (value.isEmpty) {
                        return "Field Cannot Be Blank";
                    }
                    return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                            color: Colors.blueAccent, width: 2.0
                        )
                    )
                ),
            )
        )
        );
    }

    // Builds Container with Form field for both Password and Confirm Password
    Widget _confirmPasswordField(hint) {
        return _buildContainer(Form(
            key: _cPassFormKey,
            child: TextFormField(
                controller: _cPasswordController,
                validator: (value)
                {

                    var password = _passwordController.text.toString().trim();
                    var confirmPassword = _cPasswordController.text.toString().trim();

                    if (value.isEmpty) {
                        return "Field Cannot Be Blank";
                    } else if (password != confirmPassword) {
                        return "Passwords Must Match";
                    }
                    return null;
                },
                obscureText: true,
                decoration: InputDecoration(
                    hintText: hint,
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(32.0),
                        borderSide: BorderSide(
                            color: Colors.blueAccent, width: 2.0
                        )
                    )
                ),
            )
        )
        );
    }

    // Return Container with field as child
    Widget _buildContainer(field) {
        return Container(
            padding: const EdgeInsets.all(8),
            child: field,
        );
    }

    // Verifies Input is not Null or Empty
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
        if (!_cPassFormKey.currentState.validate())
            return false;
        return true;
    }

    Future<FirebaseUser> _registerUser() async {
        final FirebaseUser newUser = (await _auth.createUserWithEmailAndPassword(
            email: _emailController.text.toString().trim(),
            password: _passwordController.text
        )).user;
        return newUser;
    }

    // Returns Container with Button Widget
    Widget _buildSubmitButton() {
        final button = RaisedButton(
            onPressed: ()
            {
                if (!_verifyInput()) {
                    return;
                }

                if (!_doPasswordsMatch()) {
                    return;
                }

                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("Creating Your Account...")));
                setState(() {
                    _saving = true;
                });
                _registerUser().then((_) => {
                    setState(() {
                        _saving = false;
                    })
                });
                Scaffold.of(context)
                    .showSnackBar(SnackBar(content: Text("Account Created!"),));

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
        final name = _nameFieldBuilder("Your Full Name");
        final email = _emailFieldBuilder("Email Address");
        final password = _passwordFieldBuilder("New Password");
        final cPassword = _confirmPasswordField("Confirm Password");
        final submitButton = _buildSubmitButton();
        final back = _backTextLink();

        return ModalProgressHUD(child: Center(
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