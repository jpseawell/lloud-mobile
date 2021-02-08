import 'package:flutter/material.dart';

import 'package:lloud_mobile/views/templates/base.dart';
import 'package:lloud_mobile/views/components/h1.dart';

class SignupTemplate extends StatelessWidget {
  final String title;
  final List<Widget> content;
  final List<Widget> bottom;

  SignupTemplate({this.title, this.content, this.bottom});

  @override
  Widget build(BuildContext context) {
    return BaseTemplate(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[H1(title)],
              )),
          Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: content,
              )),
          Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: bottom,
              )),
        ],
      ),
    ));
  }
}
