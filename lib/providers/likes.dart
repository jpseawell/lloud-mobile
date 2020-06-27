import 'package:flutter/cupertino.dart';
import 'dart:convert';

import '../util/dal.dart';

class Likes with ChangeNotifier {
  int _allowance, _remaining;
  String _refilledAt;

  int get allowance => _allowance;
  int get remaining => _remaining;
  String get refilledAt => _refilledAt;

  Future<void> fetchLikes() async {
    // TODO: Add exception handling
    final response = await DAL.instance().fetch('users/likes-balance');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    var data = jsonObj['data'];

    this._allowance = data['allowance'];
    this._remaining = data['remaining'];
    this._refilledAt = data['refilledAt'];
    notifyListeners();
  }
}
