import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: ListView(
      padding: EdgeInsets.symmetric(horizontal: 24.0),
      children: <Widget>[
        SizedBox(height: 80.0),
        Column(children: <Widget>[
          Text('Login!'),
        ]),
        SizedBox(
          height: 120.0,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Username', filled: true),
        ),
        SizedBox(
          height: 12.0,
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Password', filled: true),
          obscureText: true,
        ),
        ButtonBar(
          children: <Widget>[
            FlatButton(
              child: Text('Cancel'),
              onPressed: () {},
            ),
            RaisedButton(
              child: Text('Next'),
              onPressed: () {},
            )
          ],
        )
      ],
    )));
  }
}
