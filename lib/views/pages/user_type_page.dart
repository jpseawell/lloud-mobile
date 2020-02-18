import 'package:flutter/material.dart';

import '../_common/logo.dart';

class UserTypePage extends StatefulWidget {
  @override
  _UserTypePageState createState() => _UserTypePageState();
}

class _UserTypePageState extends State<UserTypePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            Logo(),
            SizedBox(height: 400.0),
            Text('What type of user are you?'),
          ],
        ),
      ),
    );
  }
}
