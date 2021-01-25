import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_apns/flutter_apns.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/util/network.dart';

class Apn with ChangeNotifier {
  final PushConnector _connector = createPushConnector();
  final String authToken;
  final int userId;
  bool _sent = false;

  Apn(this.authToken, this.userId);

  void init() {
    _configure();
    _connector.token.addListener(() => saveToken(_connector.token.value));
    _connector.requestNotificationPermissions();

    if (_connector is ApnsPushConnector) {
      final ApnsPushConnector connector = _connector;
      connector.shouldPresent = (x) => Future.value(true);
      connector.setNotificationCategories([
        UNNotificationCategory(
          identifier: 'MEETING_INVITATION',
          actions: [
            UNNotificationAction(
              identifier: 'ACCEPT_ACTION',
              title: 'Accept',
              options: UNNotificationActionOptions.values,
            ),
            UNNotificationAction(
              identifier: 'DECLINE_ACTION',
              title: 'Decline',
              options: [],
            ),
          ],
          intentIdentifiers: [],
          options: UNNotificationCategoryOptions.values,
        ),
      ]);
    }
  }

  void _configure() {
    _connector.configure(
      onLaunch: (data) => onPush('onLaunch', data),
      onResume: (data) => onPush('onResume', data),
      onMessage: (data) => onPush('onMessage', data),
      onBackgroundMessage: _onBackgroundMessage,
    );
  }

  Future<dynamic> onPush(String name, Map<String, dynamic> payload) {
    // storage.append('$name: $payload');

    final action = UNNotificationAction.getIdentifier(payload);
    if (action == 'MEETING_INVITATION') {
      // do something
    }

    return Future.value(true);
  }

  Future<dynamic> _onBackgroundMessage(Map<String, dynamic> data) =>
      onPush('onBackgroundMessage', data);

  Future<void> saveToken(String token) async {
    if (_sent) return;

    final url = '${Network.host}/api/v2/user/$userId/apn-tokens';
    final res = await http.post(url,
        headers: Network.headers(token: authToken),
        body: json.encode({'token': token}));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    _sent = true;
  }
}
