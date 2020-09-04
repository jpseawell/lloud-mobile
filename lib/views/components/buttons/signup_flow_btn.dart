import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class SignupFlowButton extends StatelessWidget {
  final String text;

  final Function cb;

  SignupFlowButton({this.text, this.cb});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      child: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () {
        cb();
      },
      textColor: LloudTheme.white,
      color: LloudTheme.red,
    );
  }
}
