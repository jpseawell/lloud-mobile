import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/buttons/signup_flow_btn.dart';
import 'package:lloud_mobile/views/templates/signup.dart';

class UsernamePage extends StatefulWidget {
  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final GlobalKey<FormFieldState> usernameKey = GlobalKey<FormFieldState>();
  bool usernameIsTaken = false;

  Future<bool> isUsernameTaken(String username) async {
    dynamic dal = DAL.instance();
    Response res = await dal.post('username', {'username': username},
        useAuthHeader: false);

    return !json.decode(res.body)['success'];
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      title: 'Add Your Name',
      content: <Widget>[
        TextFormField(
            key: usernameKey,
            decoration: InputDecoration(
                labelText: 'Username',
                filled: true,
                errorText:
                    usernameIsTaken ? 'This username is already in use' : null),
            onSaved: (String value) {
              Map<String, String> args =
                  ModalRoute.of(context).settings.arguments;
              print(args);
              args['username'] = value;

              return Navigator.pushNamed(context, Routes.signup_password,
                  arguments: args);
            },
            validator: (String value) {
              return value.contains('@') ? 'Username cannot contain @' : null;
            }),
        ButtonBar(
          children: <Widget>[
            SignupFlowButton(
              text: 'Next',
              cb: () async {
                bool istaken =
                    await isUsernameTaken(usernameKey.currentState.value);
                setState(() {
                  usernameIsTaken = istaken;
                });

                if (usernameKey.currentState.validate() && !usernameIsTaken) {
                  usernameKey.currentState.save();
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
