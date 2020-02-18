import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/templates/signup_flow_template.dart';

import '../_common/h1.dart';

class WelcomePage extends StatefulWidget {
  final Map<String, String> formData;

  WelcomePage(this.formData);

  @override
  _WelcomePageState createState() => _WelcomePageState(this.formData);
}

class _WelcomePageState extends State<WelcomePage> {
  final Map<String, String> formData;

  _WelcomePageState(this.formData);

  void _submitUserFormData() {
    // TODO: Submit formData to web API
  }

  @override
  Widget build(BuildContext context) {
    return SignupTemplate(
      <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          SizedBox(height: 80.0),
          Column(children: <Widget>[
            H1('Welcome to Lloud!'),
            H1('@' + formData['username']),
          ]),
          SizedBox(
            height: 120.0,
          ),
          ButtonBar(
            children: <Widget>[
              RaisedButton(
                child: Text('Get Started'),
                onPressed: () {
                  _submitUserFormData();
                },
              )
            ],
          )
        ]),
      ],
    );
  }
}
