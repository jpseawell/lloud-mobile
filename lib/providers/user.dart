import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/models/user.dart';

class UserModel with ChangeNotifier {
  User _user;

  User get user => _user;

  Future<User> fetchUser() async {
    // TODO: Add exception handling
    final response = await DAL.instance().fetch('me');
    Map<String, dynamic> decodedResponse = json.decode(response.body);

    this._user = User.fromJson(decodedResponse['data']);
    notifyListeners();
  }
}
