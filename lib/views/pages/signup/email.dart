import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:email_validator/email_validator.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';
import 'package:lloud_mobile/views/components/links/signup_flow_link.dart';
import 'package:lloud_mobile/views/templates/signup.dart';

class EmailPage extends StatefulWidget {
  @override
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final GlobalKey<FormFieldState> emailKey = GlobalKey<FormFieldState>();
  bool emailIsTaken = false;

  Future<bool> isEmailTaken(String email) async {
    dynamic dal = DAL.instance();
    Response res =
        await dal.post('email', {'email': email}, useAuthHeader: false);
    return !json.decode(res.body)['success'];
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      title: 'Sign Up!',
      content: <Widget>[
        TextFormField(
          key: emailKey,
          decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              errorText: emailIsTaken ? 'This email is already in use' : null),
          keyboardType: TextInputType.emailAddress,
          onSaved: (String value) {
            return Navigator.pushNamed(context, Routes.signup_username,
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
            SignupFlowButton(
              text: 'Next',
              cb: () async {
                bool istaken = await isEmailTaken(emailKey.currentState.value);
                setState(() {
                  emailIsTaken = istaken;
                });

                if (emailKey.currentState.validate() && !emailIsTaken) {
                  emailKey.currentState.save();
                }
              },
            )
          ],
        )
      ],
      bottom: <Widget>[
        Text(
          'Already have an account?',
          style: TextStyle(fontSize: 16),
        ),
        SignupFlowLink(
          route: Routes.login,
          text: 'Log in',
        )
      ],
    );
  }
}
