import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';

import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/views/_common/h1.dart';

class WelcomePage extends StatefulWidget {
  WelcomePage();

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Future<void> _registerUserAndLogin(BuildContext context,
      BuildContext snackCtx, Map<String, String> userData) async {
    try {
      await User.registerUser(userData);
    } catch (err) {
      Scaffold.of(snackCtx).showSnackBar(SnackBar(
          backgroundColor: LloudTheme.red,
          content: Text('Error: Something went wrong!')));
    }

    await Auth.authenticateUser(userData['email'], userData['password']);
    bool isLoggedIn = await Auth.loggedIn();

    if (isLoggedIn) {
      Provider.of<UserModel>(context, listen: false).fetchUser();
      return Navigator.pushReplacementNamed(context, '/nav');
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> userData = ModalRoute.of(context).settings.arguments;
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 40.0),
          Column(children: <Widget>[
            H1('Welcome to Lloud!'),
            H1('@' + userData['username']),
          ]),
          SizedBox(
            height: 120.0,
          ),
          ButtonBar(
            children: <Widget>[
              Builder(
                builder: (snackCtx) => RaisedButton(
                  child: Text('Get Started'),
                  onPressed: () async {
                    // I have to create a second context in order to
                    // render the snackBar
                    await _registerUserAndLogin(context, snackCtx, userData);
                  },
                  textColor: LloudTheme.white,
                  color: LloudTheme.red,
                ),
              )
            ],
          )
        ]),
      ],
    );
  }
}
