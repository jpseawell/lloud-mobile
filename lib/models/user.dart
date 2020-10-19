import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'package:lloud_mobile/util/dal.dart';

class User {
  int id;
  String firstName;
  String lastName;
  String userName;
  String email;
  String address1;
  String address2;
  String city;
  int state;
  String zipcode;
  String country;

  User({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.userName,
    @required this.email,
    @required this.address1,
    @required this.address2,
    @required this.city,
    @required this.state,
    @required this.zipcode,
    @required this.country,
  });

  static Future<User> registerUser(Map<String, String> userData) async {
    dynamic dal = DAL.instance();
    Response res = await dal.post('register', userData, useAuthHeader: false);

    if (res.statusCode == 201) {
      return User.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    User user = User(
        id: json['id'],
        firstName: json['firstname'],
        lastName: json['lastname'],
        userName: json['username'],
        email: json['email'],
        address1: json['address1'],
        address2: json['address2'],
        city: json['city'],
        state: json['state'],
        zipcode: json['zipcode'],
        country: json['country']);

    return user;
  }

  Map _toMap(User user) {
    var mapData = new Map();
    mapData["firstname"] = user.firstName;
    mapData["lastname"] = user.lastName;
    mapData["username"] = user.userName;
    mapData["email"] = user.email;
    mapData["address1"] = user.address1;
    mapData["address2"] = user.address2;
    mapData["city"] = user.city;
    mapData["state"] = user.state;
    mapData["zipcode"] = user.zipcode;
    mapData["country"] = user.country;
    return mapData;
  }

  Map _properties() {
    var mapData = new Map();
    mapData["firstname"] = this.firstName;
    mapData["lastname"] = this.lastName;
    mapData["username"] = this.userName;
    mapData["email"] = this.email;
    mapData["address1"] = this.address1;
    mapData["address2"] = this.address2;
    mapData["city"] = this.city;
    mapData["state"] = this.state;
    mapData["zipcode"] = this.zipcode;
    mapData["country"] = this.country;
    return mapData;
  }

  Future<Map<String, dynamic>> update(User user) async {
    dynamic dal = DAL.instance();
    Response response = await dal.put('users/${user.id}', _toMap(user));

    Map<String, dynamic> decodedResponse = json.decode(response.body);
    if (decodedResponse['status'] == "fail") {
      throw Exception('Failed to update user');
    }

    return decodedResponse;
  }

  bool addressComplete() {
    Map thisUser = this._properties();
    List<String> keys = ['address1', 'city', 'state', 'zipcode', 'country'];

    for (var key in keys) {
      if (thisUser[key] == null) {
        return false;
      }
    }

    return true;
  }
}
