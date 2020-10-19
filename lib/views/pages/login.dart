import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/providers/user.dart';
import 'package:lloud_mobile/providers/account.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/templates/signup.dart';
import 'package:lloud_mobile/views/components/links/signup_flow_link.dart';
import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> login(BuildContext context) async {
    // TODO: Post login activity
    try {
      await Auth.authenticateUser(email.text, password.text);
      await Provider.of<UserProvider>(context, listen: false).fetchAndNotify();
      await Provider.of<AccountProvider>(context, listen: false)
          .fetchAndNotify();
      Navigator.pushNamed(context, Routes.songs);
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
