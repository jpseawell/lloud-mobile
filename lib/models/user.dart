import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../util/dal.dart';

class User {
  int id;
  String firstName;
  String lastName;
  String userName;
  String email;
  int type;
  String address1;
  String address2;
  String city;
  String state;
  String zipcode;
  String country;

  User({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.userName,
    @required this.email,
    @required this.type,
    @required this.address1,
    @required this.address2,
    @required this.city,
    @required this.state,
    @required this.zipcode,
    @required this.country,
  });

  static Future<User> registerUser(Map<String, String> userData) async {
    dynamic dal = DAL.instance();
    Response res = await dal.post('users', userData, useAuthHeader: false);

    if (res.statusCode == 201) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      userName: json['user_name'],
      email: json['email'],
      type: json['type'],
      address1: json['address_1'],
      address2: json['address_2'],
      city: json['city'],
      state: json['state'],
      zipcode: json['zipcode'],
      country: json['country'],
    );
  }

  Map _toMap(User user) {
    var mapData = new Map();
    mapData["first_name"] = user.firstName;
    mapData["last_name"] = user.lastName;
    mapData["user_name"] = user.userName;
    mapData["email"] = user.email;
    mapData["type"] = user.type;
    mapData["address_1"] = user.address1;
    mapData["address_2"] = user.address2;
    mapData["city"] = user.city;
    mapData["state"] = user.state;
    mapData["zipcode"] = user.zipcode;
    mapData["country"] = user.country;
    return mapData;
  }

  Future<void> update(User user) async {
    try {
      dynamic dal = DAL.instance();
      Response res = await dal.put('user', _toMap(user));
    } catch (e) {
      print('Error: Could not update user');
      print(e);
      return null;
    }
  }
}
