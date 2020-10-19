import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';
import 'package:lloud_mobile/views/templates/signup.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Future<void> _registerUserAndLogin(
      BuildContext ctx, Map<String, String> userData) async {
    await User.registerUser(userData);

    User user = await Auth.authenticateAndFetchUser(
        userData['email'], userData['password']);
    bool isLoggedIn = await Auth.loggedIn();

    if (isLoggedIn) {
      Provider.of<UserProvider>(ctx, listen: false).setAndNotify(user);
      return Navigator.pushReplacementNamed(ctx, Routes.songs);
    }

    throw Exception('User authentication failed.');
  }

  @override
  Widget build(BuildContext ctx) {
    Map<String, String> userData = ModalRoute.of(context).settings.arguments;

    return SignupTemplate(
      title: 'Welcome to Lloud!\n@${userData['username']}',
      content: <Widget>[
        ButtonBar(
          children: <Widget>[
            Builder(
              builder: (snackCtx) => SignupFlowButton(
                text: 'Get Started',
                cb: () async {
                  try {
                    await _registerUserAndLogin(ctx, userData);
                  } catch (err) {
                    Scaffold.of(snackCtx).showSnackBar(SnackBar(
                        backgroundColor: LloudTheme.red,
                        content: Text('Error: User creation failed')));
                  }
                },
              ),
            )
          ],
        )
      ],
      bottom: <Widget>[],
    );
  }
}
