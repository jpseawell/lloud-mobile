import 'package:flutter/material.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';
import 'package:lloud_mobile/views/templates/signup.dart';

class PasswordPage extends StatefulWidget {
  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      title: 'Create a Password',
      content: <Widget>[
        TextFormField(
            key: _passwordKey,
            decoration: InputDecoration(labelText: 'Password', filled: true),
            obscureText: true,
            onSaved: (String value) {
              Map<String, String> args =
                  ModalRoute.of(context).settings.arguments;
              args['password'] = value;

              return Navigator.pushNamed(context, Routes.signup_welcome,
                  arguments: args);
            },
            validator: (String value) {
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }

              return null;
            }),
        ButtonBar(
          children: <Widget>[
            SignupFlowButton(
              text: 'Next',
              cb: () {
                if (_passwordKey.currentState.validate()) {
                  _passwordKey.currentState.save();
                }
              },
            )
          ],
        )
      ],
      bottom: <Widget>[],
    );
  }
}
