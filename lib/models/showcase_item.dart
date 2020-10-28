import 'package:flutter/foundation.dart';

class ShowcaseItem {
  int id;
  int entityTypeId;
  int entityId;
  int slot;
  dynamic subject;

  ShowcaseItem({
    @required this.id,
    @required this.entityTypeId,
    @required this.entityId,
    @required this.slot,
    @required this.subject,
  });

  factory ShowcaseItem.fromJson(Map<String, dynamic> json) {
    return ShowcaseItem(
      id: json['id'],
      entityTypeId: json['entity_type_id'],
      entityId: json['entity_id'],
      slot: json['slot'],
      subject: json['subject'],
    );
  }

  static List<ShowcaseItem> fromJsonList(List<dynamic> jsonList) {
    List<ShowcaseItem> items = [];
    jsonList.forEach((json) {
      items.add(ShowcaseItem.fromJson(json));
    });
    return items;
  }
}
