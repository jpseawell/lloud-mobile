import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';
import 'package:lloud_mobile/views/_common/h1.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final GlobalKey<FormFieldState> _emailKey = GlobalKey<FormFieldState>();
  bool _emailIsTaken = false;

  Future<bool> _isEmailTaken(String email) async {
    dynamic dal = DAL.instance();
    Response res =
        await dal.post('email', {'email': email}, useAuthHeader: false);

    return !json.decode(res.body)['success'];
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 40.0),
          // Putting this inside a column to center it
          H1('Sign Up!'),
        ]),
        SizedBox(
          height: 120.0,
        ),
        TextFormField(
          key: _emailKey,
          decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              errorText: _emailIsTaken ? 'This email is already in use' : null),
          keyboardType: TextInputType.emailAddress,
          onSaved: (String value) {
            return Navigator.pushNamed(context, '/username',
                arguments: <String, String>{'email': value});
          },
          validator: (String value) {
            if (!EmailValidator.validate(value)) {
              return 'Please enter a valid email';
            }

            return null;
          },
        ),
        ButtonBar(
          children: <Widget>[
            RaisedButton(
              child: Text('Next'),
              onPressed: () async {
                bool istaken =
                    await _isEmailTaken(_emailKey.currentState.value);
                setState(() {
                  _emailIsTaken = istaken;
                });

                if (_emailKey.currentState.validate() && !_emailIsTaken) {
                  _emailKey.currentState.save();
                }
              },
              textColor: LloudTheme.white,
              color: LloudTheme.red,
            )
          ],
        ),
        SizedBox(
          height: 120.0,
        ),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Already have an account?',
                style: TextStyle(fontSize: 16),
              ),
              FlatButton(
                  onPressed: () => {Navigator.pushNamed(context, '/login')},
                  child: Text(
                    'Log in',
                    style: TextStyle(fontSize: 18, color: LloudTheme.red),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
