import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/util/dal.dart';

class Notifications extends StatefulWidget {
  final int userId;

  Notifications({this.userId});

  @override
  _NotificationsState createState() => _NotificationsState(userId: this.userId);
}

class _NotificationsState extends State<Notifications> {
  final int userId;
  Future<bool> hasUnreadNotifications;
  bool unread = false;

  _NotificationsState({this.userId});

  @override
  void initState() {
    super.initState();
    hasUnreadNotifications = checkNotifications();
  }

  Future<bool> checkNotifications() async {
    final res =
        await DAL.instance().fetch('user/$userId/notifications/count?unread=1');
    Map<String, dynamic> decodedRes = json.decode(res.body);

    return (decodedRes['data']['count'] > 0);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(Routes.notifications);
      },
      child: FutureBuilder<bool>(
          future: hasUnreadNotifications,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return ReadNotifications();
            }

            return snapshot.data ? UnreadNotifications() : ReadNotifications();
          }),
    );
  }
}

class UnreadNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          height: 30,
          width: 30,
          child: Icon(Icons.favorite),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: [
              BoxShadow(
                color: LloudTheme.black.withOpacity(.25),
                offset: Offset(0.0, 1),
                blurRadius: 1,
              )
            ],
          ),
          alignment: Alignment.topRight,
          height: 10,
          width: 10,
          child: ClipOval(
            child: Material(
              color: LloudTheme.red,
              child: Container(),
            ),
          ),
        )
      ],
    );
  }
}

class ReadNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      alignment: Alignment.topRight,
      children: <Widget>[
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.zero,
          height: 30,
          width: 30,
          child: Icon(
            Icons.favorite,
            color: LloudTheme.white2.withOpacity(.85),
          ),
        ),
      ],
    );
  }
}
