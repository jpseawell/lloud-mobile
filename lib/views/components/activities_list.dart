import 'dart:convert';
import 'package:flutter/material.dart' hide Notification;
import 'package:lloud_mobile/config/lloud_theme.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/models/notification.dart';
import 'package:lloud_mobile/views/components/loading_screen.dart';
import 'package:lloud_mobile/views/components/notification_widget.dart';

class ActivitiesList extends StatefulWidget {
  @override
  _ActivitiesListState createState() => _ActivitiesListState();
}

class _ActivitiesListState extends State<ActivitiesList> {
  Future<List<Notification>> notifications;

  @override
  void initState() {
    super.initState();
    notifications = fetchNotifications();
  }

  Future<List<Notification>> fetchNotifications() async {
    final res = await DAL.instance().fetch('user/1/notifications');
    Map<String, dynamic> decodedRes = json.decode(res.body);

    return Notification.fromJsonList(decodedRes['data']['notifications']);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Notification>>(
        future: notifications,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red))
                ],
              ),
            );
          }

          return ListView(
            shrinkWrap: true,
            children: [
              for (var notification in snapshot.data)
                NotificationWidget(
                  notification: notification,
                )
            ],
          );
        });
  }
}
