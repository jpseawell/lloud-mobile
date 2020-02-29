import 'package:flutter/cupertino.dart';
import 'dart:convert';

import '../util/dal.dart';

class Likes with ChangeNotifier {
  int _allowance = 5, _remaining = 5;

  int get allowance => _allowance;
  int get remaining => _remaining;

  Future<void> fetchLikes() async {
    // TODO: Add exception handling
    final response = await DAL.instance().fetch('user/likes');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    var items = jsonObj['items'][0];

    this._allowance = items['weeklyAllowance'];
    this._remaining = items['balance'];
    notifyListeners();
  }
}
