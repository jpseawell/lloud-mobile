import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import '../util/dal.dart';

class User {
  final int id;
  final String firstName;
  final String lastName;
  final String userName;
  final String email;
  final int type;
  final String address1;
  final String address2;
  final String city;
  final String state;
  final String zipcode;
  final String country;

  const User({
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
}
