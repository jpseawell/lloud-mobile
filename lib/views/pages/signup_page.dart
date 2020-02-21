import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/pages/login_page.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';

import './user_info_page.dart';
import '../_common/h1.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailField = TextEditingController();

  void _sendEmailToNextPage(BuildContext ctx) {
    String inputEmail = emailField.text;

    // TODO: Add regex email validation
    if (inputEmail.isEmpty) {
      return;
    }

    Map<String, String> formData = {'email': inputEmail};

    Navigator.push(
        ctx, MaterialPageRoute(builder: (ctx) => UserInfoPage(formData)));
  }

  void _goToLoginPage(BuildContext ctx) {
    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => LoginPage()));
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          H1('Sign Up!'),
        ]),
        SizedBox(
          height: 120.0,
        ),
        TextField(
          controller: emailField,
          decoration: InputDecoration(labelText: 'Email', filled: true),
        ),
        ButtonBar(
          children: <Widget>[
            RaisedButton(
              child: Text('Next'),
              onPressed: () {
                _sendEmailToNextPage(context);
              },
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
                  onPressed: () => {_goToLoginPage(context)},
                  child: Text(
                    'Log in',
                    style: TextStyle(fontSize: 18),
                  ))
            ],
          ),
        )
      ],
    );
  }
}
