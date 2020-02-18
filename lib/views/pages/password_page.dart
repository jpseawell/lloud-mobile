import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/pages/welcome_page.dart';

import '../templates/signup_flow_template.dart';
import '../_common/h1.dart';

class PasswordPage extends StatefulWidget {
  final Map<String, String> formData;

  PasswordPage(this.formData);

  @override
  _PasswordPageState createState() => _PasswordPageState(this.formData);
}

class _PasswordPageState extends State<PasswordPage> {
  Map<String, String> formData;
  TextEditingController passwordField = TextEditingController();

  _PasswordPageState(this.formData);

  void _sendFormDataToWelcomePage(BuildContext ctx) {
    String inputPassword = passwordField.text;

    formData['password'] = inputPassword;

    Navigator.push(
        ctx, MaterialPageRoute(builder: (ctx) => WelcomePage(formData)));
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 80.0),
          Column(children: <Widget>[
            H1('Create a Password'),
          ]),
          SizedBox(
            height: 120.0,
          ),
          TextField(
            controller: passwordField,
            decoration: InputDecoration(labelText: 'Password', filled: true),
            obscureText: true,
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text('Next'),
                onPressed: () {
                  _sendFormDataToWelcomePage(context);
                },
              )
            ],
          )
        ]),
      ],
    );
  }
}
