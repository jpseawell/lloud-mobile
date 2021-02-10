import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/notifications.dart';

class NotificationsIcon extends StatefulWidget {
  @override
  _NotificationsIconState createState() => _NotificationsIconState();
}

class _NotificationsIconState extends State<NotificationsIcon> {
  Timer _timer;

  @override
  void initState() {
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      Provider.of<Notifications>(context, listen: false).checkAndSetUnread();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          Provider.of<Notifications>(context, listen: false).clearUnread();
          Navigator.of(context).pushNamed(Routes.notifications);
        },
        child: Consumer<Notifications>(
            builder: (context, notifications, _) => notifications.hasUnread
                ? UnreadNotifications()
                : ReadNotifications()));
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
