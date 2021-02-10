import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/util/network.dart';
import 'package:provider/provider.dart';

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
    final url = '${Network.host}/api/v2/users/$userId';
    final token = Provider.of<Auth>(context, listen: false).token;
    final res = await http.get(url, headers: Network.headers(token: token));

    if (res.statusCode == 200) {
      User user = User.fromJson(json.decode(res.body));
      return user;
    }

    return null;
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
