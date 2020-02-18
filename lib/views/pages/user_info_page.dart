import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';

import './password_page.dart';
import '../_common/h1.dart';

class UserInfoPage extends StatefulWidget {
  final Map<String, String> formData;

  UserInfoPage(this.formData);

  @override
  _UserInfoPageState createState() => _UserInfoPageState(this.formData);
}

class _UserInfoPageState extends State<UserInfoPage> {
  final Map<String, String> formData;
  TextEditingController usernameField = TextEditingController();

  _UserInfoPageState(this.formData);

  void _sendFormDataToPasswordPage(BuildContext ctx) {
    String inputUsername = usernameField.text;

    formData['username'] = inputUsername;

    Navigator.push(
        ctx, MaterialPageRoute(builder: (ctx) => PasswordPage(formData)));
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 80.0),
          Column(children: <Widget>[
            H1('Add Your Name'),
          ]),
          SizedBox(
            height: 120.0,
          ),
          TextField(
            controller: usernameField,
            decoration: InputDecoration(labelText: 'Username', filled: true),
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text('Next'),
                onPressed: () {
                  _sendFormDataToPasswordPage(context);
                },
              )
            ],
          )
        ]),
      ],
    );
  }
}
