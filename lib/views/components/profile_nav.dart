import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/util/dal.dart';

class ProfileNav extends StatefulWidget with PreferredSizeWidget {
  final int userId;

  @override
  final Size preferredSize;

  ProfileNav({Key key, this.userId})
      : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  _ProfileNavState createState() => _ProfileNavState(userId: this.userId);
}

class _ProfileNavState extends State<ProfileNav> {
  final int userId;
  Future<User> user;

  _ProfileNavState({this.userId});

  Future<User> fetchUser() async {
    final response = await DAL.instance().fetch('users/$userId');

    if (response.statusCode == 200) {
      User user = User.fromJson(json.decode(response.body));

      return user;
    }
  }

  @override
  void initState() {
    super.initState();
    user = fetchUser();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: LloudTheme.black,
      title: FutureBuilder<User>(
        future: user,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }

          return Text(
            '@${snapshot.data.userName}',
            style: TextStyle(color: LloudTheme.white),
          );
        },
      ),
    );
  }
}
