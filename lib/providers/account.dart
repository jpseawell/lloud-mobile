import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/models/account.dart';

class AccountProvider with ChangeNotifier {
  Account account;

  Future<void> fetchAndNotify() async {
    final response = await DAL.instance().fetch('accounts/me');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    if (response.statusCode != 200) {
      throw Exception('Could not retrieve account.');
    }

    this.account = Account.fromJson(decodedResponse['data']);
    notifyListeners();
  }
}
