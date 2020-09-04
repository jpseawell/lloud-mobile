import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class SignupFlowLink extends StatelessWidget {
  final String route;
  final String text;

  SignupFlowLink({this.route, this.text});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(6),
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: LloudTheme.red),
        ));
  }
}
