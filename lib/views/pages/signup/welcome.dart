import 'package:flutter/material.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';
import 'package:lloud_mobile/views/templates/signup.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext ctx) {
    Map<String, String> userData = ModalRoute.of(context).settings.arguments;

    return Consumer<Auth>(builder: (context, auth, _) {
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
                      await auth.signup(userData);
                      if (!auth.isAuth) {
                        throw Exception('User authentication failed.');
                      }

                      Provider.of<Mixpanel>(context, listen: false).track(
                          'Authenticate',
                          properties: {'Type': 'Sign Up'});
                      return Navigator.pushReplacementNamed(ctx, Routes.songs);
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
    });
  }
}
