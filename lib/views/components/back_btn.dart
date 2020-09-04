import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class BackBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlatButton.icon(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.arrow_back,
          color: LloudTheme.red,
        ),
        label: Text('Back',
            textAlign: TextAlign.start,
            style: TextStyle(fontSize: 20, color: LloudTheme.red)));
  }
}
