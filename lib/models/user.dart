import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/util/network.dart';

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

  factory User.empty() {
    return User(
        id: 0,
        firstName: '',
        lastName: '',
        userName: '',
        email: '',
        address1: '',
        address2: '',
        city: '',
        state: 0,
        zipcode: '',
        country: '');
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
        state: json['state_id'],
        zipcode: json['zipcode'],
        country: json['country']);

    return user;
  }

  static Map toMap(User user) {
    var map = new Map();
    map["id"] = user.id;
    map["firstname"] = user.firstName;
    map["lastname"] = user.lastName;
    map["username"] = user.userName;
    map["email"] = user.email;
    map["address1"] = user.address1;
    map["address2"] = user.address2;
    map["city"] = user.city;
    map["state_id"] = user.state;
    map["zipcode"] = user.zipcode;
    map["country"] = user.country;
    return map;
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

  Future<ImageFile> fetchProfileImg(String token) async {
    final url = '${Network.host}/api/v2/user/$id/image-files';
    final res = await http.get(url, headers: Network.headers(token: token));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (res.statusCode != 200) {
      throw Exception('Fetch profile image failed.');
    }

    if (decodedRes['data']['imageFile'] == null) {
      return ImageFile.empty();
    }

    return ImageFile.fromJson(decodedRes['data']['imageFile']);
  }
}
