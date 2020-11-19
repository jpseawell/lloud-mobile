import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:lloud_mobile/models/notification_subject.dart';
import 'package:lloud_mobile/util/dal.dart';

class Notification {
  int id;
  int userId;
  int type;
  DateTime seenAt;
  DateTime createdAt;
  List<NotificationSubject> subjects = [];

  Notification(
      {@required this.id,
      @required this.userId,
      @required this.type,
      this.seenAt,
      @required this.createdAt,
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
        subjects: subjects);
  }

  static List<Notification> fromJsonList(List<dynamic> jsonList) {
    List<Notification> notifications = [];
    jsonList.forEach((json) {
      notifications.add(Notification.fromJson(json));
    });
    return notifications;
  }

  static Future<void> markAsSeen(Notification notification) async {
    dynamic dal = DAL.instance();
    Response response = await dal.post(
        'user/${notification.userId}/notifications/${notification.id}/seen',
        {});
  }
}
