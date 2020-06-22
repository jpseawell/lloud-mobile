import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/util/auth.dart';
import 'package:lloud_mobile/views/_common/h1.dart';
import 'package:lloud_mobile/views/_common/h2.dart';
import 'package:lloud_mobile/views/_common/h3.dart';

import 'package:lloud_mobile/providers/user.dart';

class ListenerAccountPage extends StatefulWidget {
  @override
  _ListenerAccountPageState createState() => _ListenerAccountPageState();
}

class _ListenerAccountPageState extends State<ListenerAccountPage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context, listen: false).user;
    return Scaffold(
      body: SafeArea(
          child: ListView(
        padding: EdgeInsets.all(16.0),
        children: <Widget>[
          H1("My Account"),
          SizedBox(height: 32.0),
          H2("Personal Info"),
          Divider(),
          SizedBox(height: 8.0),
          // Username
          H3("Username: "),
          SizedBox(height: 8.0),
          Text(
            "@" + user.userName,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24.0),
          // Email
          H3("Email: "),
          SizedBox(height: 8.0),
          Text(
            user.email,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 24.0),
          // Address
          H3("Address: "),
          SizedBox(height: 8.0),
          (user.address1 == '')
              ? Text(
                  user.address1 + ' ' + user.address2,
                  style: TextStyle(fontSize: 16),
                )
              : Container(height: 0, width: 0),
          (user.city == '')
              ? Text(
                  user.city + ', ' + user.state + ' ' + user.zipcode,
                  style: TextStyle(fontSize: 16),
                )
              : Container(height: 0, width: 0),
          SizedBox(height: 16.0),
          Row(children: <Widget>[
            OutlineButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/edit-personal-info');
                },
                child:
                    Text("Edit Personal Info", style: TextStyle(fontSize: 16))),
          ]),
          SizedBox(height: 32.0),
          H2("Support"),
          Divider(),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            buttonTextTheme: ButtonTextTheme.normal,
            children: <Widget>[
              OutlineButton(
                  onPressed: () async {
                    const url = 'https://lloudapp.com/contact';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text("Contact", style: TextStyle(fontSize: 16))),
              OutlineButton(
                  onPressed: () async {
                    const url = 'https://lloudapp.com/help';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text("Help", style: TextStyle(fontSize: 16))),
              OutlineButton(
                  onPressed: () async {
                    const url = 'https://lloudapp.com/terms';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child:
                      Text("Terms of Service", style: TextStyle(fontSize: 16))),
              OutlineButton(
                  onPressed: () async {
                    const url = 'https://lloudapp.com/privacy';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      throw 'Could not launch $url';
                    }
                  },
                  child: Text("Privacy Policy", style: TextStyle(fontSize: 16)))
            ],
          ),
          SizedBox(height: 40.0),
          FlatButton(
              textColor: LloudTheme.red,
              onPressed: () async {
                await Auth.clearToken();
                return Navigator.pushNamed(context, '/login');
              },
              child: Text("Log Out", style: TextStyle(fontSize: 16))),
          SizedBox(height: 16.0),
        ],
      )),
    );
  }
}
