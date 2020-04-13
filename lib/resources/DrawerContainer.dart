import 'package:flutter/material.dart';

import 'package:asltranslate/resources/Auth.dart';
import 'package:asltranslate/resources/FireStore.dart';
import 'package:asltranslate/pages/asl_translate.dart';

class DrawerContainer {

  final List<Map<IconData, String>> _drawerContents = [
    {Icons.person: "Profile"},
    {Icons.exit_to_app: "Log Out"}
  ];

  static BuildContext _ctx;

  Widget drawerContainer(BuildContext context) {
    _ctx = context;
    return Drawer(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: _drawerContents.length,
          itemBuilder: (BuildContext context, int index) {
            Map<IconData, String> map = _drawerContents[index];
            IconData icon = map.keys.toList()[0];
            return _drawerContentWidget(icon, map[icon]);
          },
        ));
  }

  Widget _drawerContentWidget(IconData icon, String text) {
    return GestureDetector(
        onTap: () {
          _drawerFunction(text);
        },
        child: Container(
          child: Row(
            children: <Widget>[
              Container(
                padding: EdgeInsets.fromLTRB(20.0, 30.0, 5.0, 10.0),
                child: Icon(
                  icon,
                  size: 40.0,
                ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(5.0, 30.0, 5.0, 10.0),
                child: Text(
                  text,
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ],
          ),
        ));
  }

  void _drawerFunction(String text) {
    switch (text) {
      case "Profile":
        {
          _showUserProfile();
        }
        break;
      case "Log Out":
        {
          _signOutUser();
        }
        break;
    }
  }

  void _signOutUser() async {
    try {
      await Authentication().signOut().then((val) {
        if (val) {
          Navigator.of(_ctx).push(_loginPageRoute());
        } else {
          Scaffold.of(_ctx).showSnackBar(SnackBar(
              content: Text("Error, Something Went Wrong, Please Try Again..."),
              duration: new Duration(seconds: 3)
          ));
        }
      });
    } catch(e) {
      Scaffold.of(_ctx).showSnackBar(SnackBar(
          content: Text("Error, Something Went Wrong, Please Try Again..."),
          duration: new Duration(seconds: 3)
      ));
    }
  }

  Future<void> _showUserProfile() async {
    final user = await FireStore().retrieveUserInfo();
    Navigator.of(_ctx).pop();
    return showDialog<void>(
        context: _ctx,
        builder: (BuildContext context) {
          return new Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)
            ),
            child: Container(
              height: 500,
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Icon(
                      Icons.person,
                      size: 120.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "${user['firstName']} ${user['lastName']}",
                      style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      "${user['email']}",
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
    );
  }

  Route _loginPageRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => ASLTranslate(),
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
}