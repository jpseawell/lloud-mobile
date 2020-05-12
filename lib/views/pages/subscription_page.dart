import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import 'package:lloud_mobile/views/_common/h1.dart';

class SubscriptionPage extends StatefulWidget {
  @override
  _SubscriptionPageState createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
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
                H1('Get More Likes'),
                SizedBox(height: 20.0),
                Text(
                    'A Lloud monthly subscription provides you with 20 likes per month. Likes can bring you points, and points may be redeemed for exclusive merch from the Lloud store.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, height: 1.5)),
                SizedBox(height: 80.0),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 14.0),
                          onPressed: () {
                            print('yayyyy :)');
                          },
                          color: LloudTheme.red,
                          textColor: LloudTheme.white,
                          child: Text(
                            'Subscribe Now - \$10',
                            style: TextStyle(fontSize: 20),
                          ),
                        ))
                  ],
                ),
                SizedBox(height: 8.0),
                Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: FlatButton(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          textColor: LloudTheme.red,
                          child: Text(
                            'Maybe Later',
                            style: TextStyle(fontSize: 20),
                          ),
                        ))
                  ],
                ),
              ]),
        ],
      )),
    );
  }
}
