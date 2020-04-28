import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';
import 'package:lloud_mobile/views/_common/h1.dart';

class PasswordPage extends StatefulWidget {
  PasswordPage();

  @override
  _PasswordPageState createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final GlobalKey<FormFieldState> _passwordKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 40.0),
          Column(children: <Widget>[
            H1('Create a Password'),
          ]),
          SizedBox(
            height: 120.0,
          ),
          TextFormField(
              key: _passwordKey,
              decoration: InputDecoration(labelText: 'Password', filled: true),
              obscureText: true,
              onSaved: (String value) {
                Map<String, String> args =
                    ModalRoute.of(context).settings.arguments;
                args['password'] = value;

                return Navigator.pushNamed(context, '/welcome',
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
              RaisedButton(
                child: Text('Next'),
                onPressed: () {
                  if (_passwordKey.currentState.validate()) {
                    _passwordKey.currentState.save();
                  }
                },
                textColor: LloudTheme.white,
                color: LloudTheme.red,
              )
            ],
          )
        ]),
      ],
    );
  }
}
