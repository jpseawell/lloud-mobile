import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:lloud_mobile/util/dal.dart';

class Points with ChangeNotifier {
  int _points;

  int get points => _points;

  Future<void> fetchPoints() async {
    // TODO: Add exception handling
    final response = await DAL.instance().fetch('users/points');
    Map<String, dynamic> jsonObj = json.decode(response.body);

    this._points = jsonObj['data']['points'];
    notifyListeners();
  }
}
