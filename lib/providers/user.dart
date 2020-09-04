import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/models/user.dart';
import 'package:lloud_mobile/util/dal.dart';

class UserProvider with ChangeNotifier {
  User user;

  void setAndNotify(User user) {
    this.user = user;
    notifyListeners();
  }

  Future<void> fetchAndNotify() async {
    final response = await DAL.instance().fetch('me');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception('Could not retrieve user.');
    }

    this.user = User.fromJson(decodedResponse['data']);
    notifyListeners();
  }
}
