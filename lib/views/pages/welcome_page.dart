import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';

import '../../util/auth.dart';

import '../pages/nav_page.dart';
import '../../models/user.dart';
import '../_common/h1.dart';

class WelcomePage extends StatefulWidget {
  final Map<String, String> formData;

  WelcomePage(this.formData);

  @override
  _WelcomePageState createState() => _WelcomePageState(this.formData);
}

class _WelcomePageState extends State<WelcomePage> {
  final Map<String, String> formData;
  Future<bool> isLoggedIn;

  _WelcomePageState(this.formData);

  Future<void> _registerUserAndLogin(BuildContext ctx) async {
    // TODO: Try/catch this and update error state on err

    try {
      await User.registerUser(formData);
    } catch (err) {
      Scaffold.of(ctx).showSnackBar(SnackBar(
          backgroundColor: LloudTheme.red,
          content: Text('Error: Something went wrong!')));
    }

    await Auth.authenticateUser(formData['email'], formData['password']);
    bool isLoggedIn = await Auth.loggedIn();

    // TODO: Look into erasing history at this point so the user can't go backwards

    if (isLoggedIn) {
      Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => NavPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 80.0),
          Column(children: <Widget>[
            H1('Welcome to Lloud!'),
            H1('@' + formData['user_name']),
          ]),
          SizedBox(
            height: 120.0,
          ),
          ButtonBar(
            children: <Widget>[
              Builder(
                builder: (context2) => RaisedButton(
                  child: Text('Get Started'),
                  onPressed: () async {
                    await _registerUserAndLogin(context2);
                  },
                ),
              )
            ],
          )
        ]),
      ],
    );
  }
}
