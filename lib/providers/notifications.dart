import 'dart:convert';

import 'package:flutter/material.dart' hide Notification;
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/models/notification.dart';
import 'package:lloud_mobile/util/network.dart';

class Notifications with ChangeNotifier {
  String authToken;
  int userId;
  List<Notification> _notifications = [];
  bool _hasUnread = false;

  Notifications(this.authToken, this.userId);

  bool get hasUnread => _hasUnread;
  List<Notification> get notifications => [..._notifications];

  Notifications update(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;

    authToken == null ? clear() : fetchAndSetNotifications();

    return this;
  }

  void clear() {
    _notifications = [];
    _hasUnread = false;
    notifyListeners();
  }

  Future<List<Notification>> _fetchNotifications(int page) async {
    final url = '${Network.host}/api/v2/user/$userId/notifications?page=$page';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success') {
      return [];
    }

    return Notification.fromJsonList(
        decodedRes['data']['notifications'] as List<dynamic>);
  }

  Future<void> fetchAndSetNotifications({int page = 1}) async {
    final notifications = await _fetchNotifications(page);
    if (notifications.isEmpty) return notifications;

    _notifications.addAll(notifications);
    notifyListeners();
  }

  Future<void> reset() async {
    _notifications = [];
    await fetchAndSetNotifications();
  }

  Future<void> markAsSeen(Notification notification) async {
    final url =
        '${Network.host}/api/v2/user/$userId/notifications/${notification.id}/seen';
    await http.post(url,
        headers: Network.headers(token: authToken), body: json.encode({}));
  }

  Future<void> checkAndSetUnread() async {
    final notifications = await _fetchNotifications(1);
    final unreadIndex =
        notifications.indexWhere((notification) => notification.seenAt == null);

    _hasUnread = unreadIndex > -1;
    notifyListeners();
  }

  void clearUnread() {
    _hasUnread = false;
    notifyListeners();
  }
}
