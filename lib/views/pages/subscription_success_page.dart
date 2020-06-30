import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class SubscriptionSuccessPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 36.0),
        children: <Widget>[
          SizedBox(height: 200.0),
          Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Sweeet!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Raleway')),
                SizedBox(height: 20.0),
                Text(
                    "You are now a Llouder: 20 likes a month subscriber. Get out there and use those likes.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.5)),
                SizedBox(height: 40.0),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          onPressed: () {
                            Navigator.pushNamed(context, '/nav');
                          },
                          color: LloudTheme.red,
                          textColor: LloudTheme.white,
                          child: Text(
                            'Go Use My Likes!',
                            style: TextStyle(fontSize: 20),
                          ),
                        ))
                  ],
                ),
              ]),
        ],
      ),
    ));
  }
}
