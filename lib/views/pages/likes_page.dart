import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/_common/h1.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/pages/subscription_page.dart';
import 'package:lloud_mobile/providers/likes.dart';

class LikesPage extends StatefulWidget {
  @override
  _LikesPageState createState() => _LikesPageState();
}

class _LikesPageState extends State<LikesPage> {
  @override
  Widget build(BuildContext context) {
    final likes = Provider.of<Likes>(context);
    return Builder(builder: (context) {
      return (likes.remaining > 0) ? LikesBalancePage() : SubscriptionPage();
    });
  }
}

class LikesBalancePage extends StatefulWidget {
  @override
  _LikesBalancePageState createState() => _LikesBalancePageState();
}

class _LikesBalancePageState extends State<LikesBalancePage> {
  @override
  Widget build(BuildContext context) {
    final likes = Provider.of<Likes>(context);
    return Scaffold(
        body: SafeArea(
            child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 36.0),
                children: <Widget>[
          SizedBox(height: 125.0),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            Text(
              "${likes.remaining}",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 128,
                  fontWeight: FontWeight.bold,
                  color: LloudTheme.black),
            )
          ]),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            (likes.remaining > 1) ? H1("Likes Left...") : H1("Like Left...")
          ]),
          SizedBox(height: 40.0),
          Text(
            "Your next like refill is scheduled for:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 8.0),
          Text(
            likes.refilledAt,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 40.0),
          Row(children: <Widget>[
            Expanded(
                flex: 1,
                child: RaisedButton(
                  padding: EdgeInsets.symmetric(vertical: 14.0),
                  onPressed: () {
                    Navigator.pushNamed(context, '/subscription');
                  },
                  color: LloudTheme.red,
                  textColor: LloudTheme.white,
                  child: Text(
                    'Get More Likes',
                    style: TextStyle(fontSize: 20),
                  ),
                ))
          ]),
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
          )
        ])));
  }
}
