import 'package:flutter/material.dart' hide Notification;

import 'package:lloud_mobile/models/notification.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/views/components/notifications/received_point_for_like.dart';

class NotificationWidget extends StatefulWidget {
  final Notification notification;

  NotificationWidget({this.notification});

  @override
  _NotificationWidgetState createState() =>
      _NotificationWidgetState(notification: this.notification);
}

class _NotificationWidgetState extends State<NotificationWidget> {
  final Notification notification;

  _NotificationWidgetState({this.notification});

  @override
  void initState() {
    super.initState();
    if (notification.seenAt == null) {
      Notification.markAsSeen(notification);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;

    switch (notification.type) {
      case 1:
        widget = ReceivedPointForLike(
          notification: notification,
        );
        break;
      default:
    }

    return Container(
      child: widget,
    );
  }
}
