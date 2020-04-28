import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:lloud_mobile/util/dal.dart';

import 'package:lloud_mobile/views/templates/signup_flow_template.dart';
import 'package:lloud_mobile/views/_common/H1.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class UsernamePage extends StatefulWidget {
  UsernamePage();

  @override
  _UsernamePageState createState() => _UsernamePageState();
}

class _UsernamePageState extends State<UsernamePage> {
  final GlobalKey<FormFieldState> _usernameKey = GlobalKey<FormFieldState>();
  bool _usernameIsTaken = false;

  Future<bool> _isUsernameTaken(String username) async {
    dynamic dal = DAL.instance();
    Response res = await dal.post('username', {'username': username},
        useAuthHeader: false);

    return !json.decode(res.body)['success'];
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 40.0),
          Column(children: <Widget>[
            H1('Add Your Name'),
          ]),
          SizedBox(
            height: 120.0,
          ),
          TextFormField(
              key: _usernameKey,
              decoration: InputDecoration(
                  labelText: 'Username',
                  filled: true,
                  errorText: _usernameIsTaken
                      ? 'This username is already in use'
                      : null),
              onSaved: (String value) {
                Map<String, String> args =
                    ModalRoute.of(context).settings.arguments;
                args['username'] = value;

                return Navigator.pushNamed(context, '/password',
                    arguments: args);
              },
              validator: (String value) {
                return value.contains('@') ? 'Username cannot contain @' : null;
              }),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text('Next'),
                onPressed: () async {
                  bool istaken =
                      await _isUsernameTaken(_usernameKey.currentState.value);
                  setState(() {
                    _usernameIsTaken = istaken;
                  });

                  if (_usernameKey.currentState.validate() &&
                      !_usernameIsTaken) {
                    _usernameKey.currentState.save();
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
