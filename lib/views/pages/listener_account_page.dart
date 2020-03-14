import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/_common/listener_account_form.dart';

import '../../util/dal.dart';
import '../../models/user.dart';

class ListenerAccountPage extends StatefulWidget {
  @override
  _ListenerAccountPageState createState() => _ListenerAccountPageState();
}

class _ListenerAccountPageState extends State<ListenerAccountPage> {
  Future<User> futureUser;

  Future<User> fetchUser() async {
    final response = await DAL.instance().fetch('user');
    Map<String, dynamic> jsonObj = json.decode(response.body);

    return User.fromJson(jsonObj['items'][0]);
  }

  @override
  void initState() {
    super.initState();
    futureUser = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: futureUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListenerAccountForm(snapshot.data);
          }

          return Text('Loading...');
        });
  }
}
