import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/_common/h1.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';

import '../../util/auth.dart';

import '../pages/nav_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> _authenticateUserAndLogin(BuildContext ctx) async {
    String inputEmail = email.text;
    String inputPassword = password.text;

    // TODO: trim un & pw

    await Auth.authenticateUser(inputEmail, inputPassword);
    bool isLoggedIn = await Auth.loggedIn();

    if (isLoggedIn) {
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => NavPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(<Widget>[
      SizedBox(height: 80.0),
      Column(children: <Widget>[
        H1('Login!'),
      ]),
      SizedBox(
        height: 120.0,
      ),
      TextField(
        controller: email,
        decoration: InputDecoration(labelText: 'Username', filled: true),
      ),
      SizedBox(
        height: 12.0,
      ),
      TextField(
        controller: password,
        decoration: InputDecoration(labelText: 'Password', filled: true),
        obscureText: true,
      ),
      ButtonBar(
        children: <Widget>[
          RaisedButton(
            child: Text('Log in'),
            onPressed: () async {
              await _authenticateUserAndLogin(context);
            },
          )
        ],
      )
    ]);
  }
}
