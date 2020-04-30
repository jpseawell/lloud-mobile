import 'package:flutter/cupertino.dart';
import 'dart:convert';

import '../util/dal.dart';

class Likes with ChangeNotifier {
  int _allowance, _remaining;

  int get allowance => _allowance;
  int get remaining => _remaining;

  Future<void> fetchLikes() async {
    // TODO: Add exception handling
    final response = await DAL.instance().fetch('users/likes-balance');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    var data = jsonObj['data'];

    this._allowance = data['allowance'];
    this._remaining = data['remaining'];
    notifyListeners();
  }
}
