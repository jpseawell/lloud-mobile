import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../util/dal.dart';

class User {
  final int id;
  final String username;
  final String email;
  final int type;

  const User({
    @required this.id,
    @required this.username,
    @required this.email,
    @required this.type,
  });

  static Future<User> registerUser(Map<String, String> userData) async {
    dynamic dal = DAL.instance();
    Response res = await dal.post('user', userData);

    if (res.statusCode == 201) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['username'],
      type: json['type'],
    );
  }
}
