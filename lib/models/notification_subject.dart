import 'package:flutter/foundation.dart';

class NotificationSubject {
  int id;
  int notificationId;
  int entityTypeId;
  int entityId;
  dynamic subject;

  NotificationSubject({
    @required this.id,
    @required this.notificationId,
    @required this.entityTypeId,
    @required this.entityId,
    @required this.subject,
  });

  factory NotificationSubject.fromJson(Map<String, dynamic> json) {
    dynamic subject;

    switch (json['entity_type_id']) {
      case 1:
        subject = json['artist'];
        break;
      case 2:
        subject = json['user'];
        break;
      case 3:
        subject = json['song'];
        break;
      default:
    }

    return NotificationSubject(
        id: json['id'],
        notificationId: json['notification_id'],
        entityTypeId: json['entity_type_id'],
        entityId: json['entity_id'],
        subject: subject);
  }
}
