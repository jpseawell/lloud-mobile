import 'package:flutter/material.dart';
import 'package:lloud_mobile/providers/auth.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/templates/signup.dart';
import 'package:lloud_mobile/views/components/links/signup_flow_link.dart';
import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login(BuildContext context) async {
    try {
      final authProvider = Provider.of<Auth>(context, listen: false);
      await authProvider
          .login({'email': email.text, 'password': password.text});
      if (!authProvider.isAuth) throw Exception('User authentication failed.');

      Provider.of<Mixpanel>(context, listen: false)
          .track('Authenticate', properties: {'Type': 'Login'});
      return Navigator.pushReplacementNamed(context, Routes.songs);
    } catch (e) {
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: LloudTheme.red,
          content: Text('Incorrect username or password')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      title: 'Login!',
      content: <Widget>[
        TextField(
          controller: email,
          decoration: InputDecoration(labelText: 'Email', filled: true),
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
          alignment: MainAxisAlignment.end,
          children: <Widget>[
            Builder(builder: (snackCtx) {
              return SignupFlowButton(
                text: 'Log in',
                cb: () async {
                  await login(snackCtx);
                },
              );
            }),
          ],
        ),
      ],
      bottom: <Widget>[
        SignupFlowLink(route: Routes.forgot_password, text: 'Forgot password?'),
        Text(
          '·',
          textAlign: TextAlign.end,
        ),
        SignupFlowLink(route: Routes.home, text: 'Sign up for Lloud'),
      ],
    );
  }
}
