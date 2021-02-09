import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/util/network.dart';
import 'package:lloud_mobile/views/templates/signup.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormFieldState> _recoverEmailKey =
      GlobalKey<FormFieldState>();
  bool _emailIsFound = false;
  bool _requestSent = false;
  bool _complete = false;

  void _checkComplete() {
    setState(() {
      _complete = (_emailIsFound && _requestSent);
    });
  }

  Future<bool> _isEmailFound(String email) async {
    final url = '${Network.host}/api/v2/auth/recover';
    final res = await http.post(url,
        headers: Network.headers(), body: json.encode({'email': email}));

    if (res.statusCode != 200) return false;

    Map<String, dynamic> decodedResponse = json.decode(res.body);
    return decodedResponse['success'];
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      title: 'Find your account:',
      content: _complete
          ? [
              Text("A password recovery email was sent to your email address",
                  style: TextStyle(fontSize: 16.0)),
            ]
          : [
              Text("Enter your email address",
                  style: TextStyle(fontSize: 16.0)),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                key: _recoverEmailKey,
                decoration: InputDecoration(
                    labelText: 'Email',
                    filled: true,
                    errorText: (!_emailIsFound && _requestSent)
                        ? 'Email not found'
                        : null),
                keyboardType: TextInputType.emailAddress,
                onSaved: (String value) {},
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
                    child: Text('Search'),
                    onPressed: () async {
                      bool emailFound = await _isEmailFound(
                          _recoverEmailKey.currentState.value);
                      setState(() {
                        _emailIsFound = emailFound;
                        _requestSent = true;
                      });

                      _checkComplete();
                    },
                    textColor: LloudTheme.white,
                    color: LloudTheme.red,
                  ),
                ],
              ),
            ],
      bottom: [
        FlatButton(
            padding: EdgeInsets.all(6),
            onPressed: () => {Navigator.pushNamed(context, '/login')},
            child: Text(
              'Go back',
              style: TextStyle(fontSize: 18, color: LloudTheme.red),
            ))
      ],
    );
  }
}
