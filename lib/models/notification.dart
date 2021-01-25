import 'package:flutter/foundation.dart';

import 'package:lloud_mobile/models/notification_subject.dart';

class Notification {
  int id;
  int userId;
  int type;
  DateTime seenAt;
  DateTime createdAt;
  String createdAtFromNow;
  List<NotificationSubject> subjects = [];

  Notification(
      {@required this.id,
      @required this.userId,
      @required this.type,
      this.seenAt,
      @required this.createdAt,
      @required this.createdAtFromNow,
      this.subjects});

  factory Notification.fromJson(Map<String, dynamic> json) {
    List<NotificationSubject> subjects = [];

    if (json.containsKey('subjects')) {
      List<dynamic> subjectsMap = json['subjects'];

      subjectsMap.forEach((element) {
        subjects.add(NotificationSubject.fromJson(element));
      });
    }

    return Notification(
        id: json['id'],
        userId: json['user_id'],
        type: json['type'],
        seenAt:
            (json['seen_at'] != null) ? DateTime.parse(json['seen_at']) : null,
        createdAt: (json['created_at'] != null)
            ? DateTime.parse(json['created_at'])
            : null,
        createdAtFromNow: json['created_at_from_now'],
        subjects: subjects);
  }

  static List<Notification> fromJsonList(List<dynamic> jsonList) {
    List<Notification> notifications = [];
    jsonList.forEach((json) {
      notifications.add(Notification.fromJson(json));
    });
    return notifications;
  }
}
